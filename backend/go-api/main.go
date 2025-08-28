package main

import (
	"encoding/json"
	"log"
	"net/http"
	"strings"

	"github.com/golang-jwt/jwt/v5"
)

type Post struct {
	ID      int    `json:"id"`
	Content string `json:"content"`
	Flagged bool   `json:"flagged"`
	Reason  string `json:"reason,omitempty"`
	Author  string `json:"author"`
	User    string `json:"user"`
}

type User struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

var posts []Post
var nextID = 1
var users = make(map[string]string) // username -> password
var jwtKey = []byte("supersecretkey")

func enableCORS(w http.ResponseWriter) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
}

func getPosts(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)
	if r.Method == http.MethodOptions {
		return
	}
	log.Println("GET /posts")
	json.NewEncoder(w).Encode(posts)
}

// ✅ helper to extract username from token
func getUsernameFromToken(r *http.Request) (string, error) {
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" {
		return "Anon", nil // no token → anon
	}

	parts := strings.Split(authHeader, " ")
	if len(parts) != 2 || parts[0] != "Bearer" {
		return "Anon", nil
	}

	tokenStr := parts[1]
	token, err := jwt.Parse(tokenStr, func(token *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})
	if err != nil || !token.Valid {
		return "Anon", nil
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok {
		if username, ok := claims["username"].(string); ok {
			return username, nil
		}
	}
	return "Anon", nil
}

func addPost(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)
	if r.Method == http.MethodOptions {
		return
	}

	var post Post
	if err := json.NewDecoder(r.Body).Decode(&post); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// ✅ Try to parse JWT (optional)
	authHeader := r.Header.Get("Authorization")
	user := "anon"
	if authHeader != "" {
		parts := strings.Split(authHeader, " ")
		if len(parts) == 2 && parts[0] == "Bearer" {
			tokenStr := parts[1]
			token, _ := jwt.Parse(tokenStr, func(token *jwt.Token) (interface{}, error) {
				return jwtKey, nil
			})
			if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
				user = claims["username"].(string)
			}
		}
	}

	post.User = user

	// 🔍 Simple moderation
	dangerousWords := []string{"kill", "bomb", "attack", "murder"}
	contentLower := strings.ToLower(post.Content)
	for _, word := range dangerousWords {
		if strings.Contains(contentLower, word) {
			post.Flagged = true
			post.Reason = "Contains prohibited word: " + word
			break
		}
	}

	post.ID = nextID
	nextID++
	posts = append(posts, post)
	log.Printf("POST /posts - New post by %s: %+v\n", user, post)
	json.NewEncoder(w).Encode(post)
}

func registerUser(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)
	if r.Method == http.MethodOptions {
		return
	}

	var user User
	if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	if _, exists := users[user.Username]; exists {
		http.Error(w, "User already exists", http.StatusBadRequest)
		return
	}

	users[user.Username] = user.Password
	json.NewEncoder(w).Encode(map[string]string{"message": "User registered"})
}

func loginUser(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)
	if r.Method == http.MethodOptions {
		return
	}

	var user User
	if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	storedPass, exists := users[user.Username]
	if !exists || storedPass != user.Password {
		http.Error(w, "Invalid credentials", http.StatusUnauthorized)
		return
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"username": user.Username,
	})
	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		http.Error(w, "Error creating token", http.StatusInternalServerError)
		return
	}

	log.Printf("LOGIN success for user=%s token=%s\n", user.Username, tokenString) // ✅ Debug log
	json.NewEncoder(w).Encode(map[string]string{"token": tokenString})
}

func main() {
	http.HandleFunc("/register", registerUser)
	http.HandleFunc("/login", loginUser)
	http.HandleFunc("/posts", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			getPosts(w, r)
		case http.MethodPost:
			addPost(w, r) // ✅ now allows anon OR logged-in
		case http.MethodOptions:
			enableCORS(w)
		default:
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})

	log.Println("Server running on 0.0.0.0:8080")
	log.Fatal(http.ListenAndServe("0.0.0.0:8080", nil))
}
