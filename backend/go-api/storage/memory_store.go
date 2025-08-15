package storage

import (
	"anonapp/models"
)

var Posts []models.Post
var nextID = 1

func GetPosts() []models.Post {
	return Posts
}

func AddPost(post models.Post) models.Post {
	post.ID = nextID
	nextID++
	Posts = append(Posts, post)
	return post
}
