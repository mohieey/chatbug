package services

import (
	"chatbugGo/models"
)

type ChatService struct {
}

func (c *ChatService) Create(applicationToken string) (*models.Chat, error) {
	chat := models.Chat{
		Number:           4,
		ApplicationToken: applicationToken,
	}

	return &chat, nil
}
