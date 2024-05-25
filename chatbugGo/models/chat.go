package models

type Chat struct {
	Number           int64  `json:"number"`
	Name             string `json:"name"`
	ApplicationToken string `json:"application_token"`
}
