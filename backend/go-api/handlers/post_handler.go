package handlers

import (
	"anonapp/models"
	"anonapp/storage"
	"encoding/json"
	"net/http"
	"strings"
)

func GetPostsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(storage.GetPosts())
}

func CreatePostHandler(w http.ResponseWriter, r *http.Request) {
	var post models.Post
	err := json.NewDecoder(r.Body).Decode(&post)
	if err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}

	// Simple moderation filter
	lower := strings.ToLower(post.Content)
	if strings.Contains(lower, "bomb") || strings.Contains(lower, "suicide") {
		post.Flagged = true
		post.Reason = "Contains flagged keywords"
	}

	storage.AddPost(post)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(post)
}
