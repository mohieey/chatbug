package models

type Message struct {
	Number           int64  `json:"number"`
	Body             string `json:"body"`
	ChatNumber       int64  `json:"chat_number"`
	ApplicationToken string `json:"application_token"`
}
