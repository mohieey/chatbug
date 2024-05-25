package models

type Message struct {
	Number           int64  `json:"number"`
	Text             string `json:"text"`
	ChatNumber       int64  `json:"chat_number"`
	ApplicationToken string `json:"application_token"`
}
