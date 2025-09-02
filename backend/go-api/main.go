package main

import (
	"encoding/json"
	"log"
	"net/http"
	"strings"

	"github.com/golang-jwt/jwt/v5"
)

type Post struct {
	ID      int     `json:"id"`
	Content string  `json:"content"`
	Flagged bool    `json:"flagged"`
	Reason  string  `json:"reason,omitempty"`
	Author  *string `json:"author,omitempty"` // nil => Anonymous
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

func bearerUsername(r *http.Request) (string, bool) {
	auth := r.Header.Get("Authorization")
	if auth == "" {
		return "", false
	}
	parts := strings.Split(auth, " ")
	if len(parts) != 2 || strings.ToLower(parts[0]) != "bearer" {
		return "", false
	}
	tokenStr := parts[1]
	tok, err := jwt.Parse(tokenStr, func(t *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})
	if err != nil || !tok.Valid {
		return "", false
	}
	if claims, ok := tok.Claims.(jwt.MapClaims); ok {
		if u, ok := claims["username"].(string); ok && u != "" {
			return u, true
		}
	}
	return "", false
}

func getPosts(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)
	if r.Method == http.MethodOptions {
		return
	}
	json.NewEncoder(w).Encode(posts)
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

	// Optional author if token present
	if u, ok := bearerUsername(r); ok {
		post.Author = &u
	}

	// Simple moderation
	dangerous := []string{"kill", "bomb", "attack", "murder"}
	lc := strings.ToLower(post.Content)
	for _, wv := range dangerous {
		if strings.Contains(lc, wv) {
			post.Flagged = true
			post.Reason = "Contains prohibited word: " + wv
			break
		}
	}

	post.ID = nextID
	nextID++
	posts = append(posts, post)
	log.Printf("POST /posts -> %+v\n", post)
	json.NewEncoder(w).Encode(post)
}

func registerUser(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)
	if r.Method == http.MethodOptions {
		return
	}
	var u User
	if err := json.NewDecoder(r.Body).Decode(&u); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	if _, exists := users[u.Username]; exists {
		http.Error(w, "User already exists", http.StatusBadRequest)
		return
	}
	users[u.Username] = u.Password
	json.NewEncoder(w).Encode(map[string]string{"message": "User registered"})
}

func loginUser(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)
	if r.Method == http.MethodOptions {
		return
	}
	var u User
	if err := json.NewDecoder(r.Body).Decode(&u); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	pass, ok := users[u.Username]
	if !ok || pass != u.Password {
		http.Error(w, "Invalid credentials", http.StatusUnauthorized)
		return
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"username": u.Username,
	})
	tokenStr, err := token.SignedString(jwtKey)
	if err != nil {
		http.Error(w, "Error creating token", http.StatusInternalServerError)
		return
	}

	log.Printf("LOGIN ok user=%s", u.Username)
	json.NewEncoder(w).Encode(map[string]string{
		"token":    tokenStr,
		"username": u.Username,
	})
}

func main() {
	http.HandleFunc("/register", registerUser)
	http.HandleFunc("/login", loginUser)
	http.HandleFunc("/posts", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			getPosts(w, r)
		case http.MethodPost:
			// Anonymous allowed (no middleware) — author set if token present
			addPost(w, r)
		case http.MethodOptions:
			enableCORS(w)
		default:
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})

	log.Println("Server running on 0.0.0.0:8080")
	log.Fatal(http.ListenAndServe("0.0.0.0:8080", nil))
}
