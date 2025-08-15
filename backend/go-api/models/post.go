package models

type Post struct {
	ID      int    `json:"id"`
	Content string `json:"content"`
	Flagged bool   `json:"flagged"`
	Reason  string `json:"reason,omitempty"`
}
