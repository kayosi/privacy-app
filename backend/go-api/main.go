package main

import (
	"encoding/json"
	"log"
	"net/http"
	"strings"
)

type Post struct {
	ID      int    `json:"id"`
	Content string `json:"content"`
	Flagged bool   `json:"flagged"`
	Reason  string `json:"reason,omitempty"`
}

var posts []Post
var nextID = 1

func enableCORS(w http.ResponseWriter) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
}

func getPosts(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)
	if r.Method == http.MethodOptions {
		return
	}
	log.Println("GET /posts")
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

	// 🔍 Basic moderation: flag if dangerous words detected
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
	log.Printf("POST /posts - New post: %+v\n", post)
	json.NewEncoder(w).Encode(post)
}

func main() {
	http.HandleFunc("/posts", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			getPosts(w, r)
		case http.MethodPost:
			addPost(w, r)
		case http.MethodOptions:
			enableCORS(w)
			return
		default:
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})

	log.Println("Server running on 0.0.0.0:8080")
	log.Fatal(http.ListenAndServe("0.0.0.0:8080", nil))
}
