package services

import (
	"chatbugGo/models"

	workers "github.com/digitalocean/go-workers2"
	"github.com/go-redis/redis"
)

type ChatService struct {
	Producer    *workers.Producer
	RedisClient *redis.Client
}

func (c *ChatService) Create(applicationToken string) (*models.Chat, error) {
	chat := models.Chat{
		Number:           4,
		ApplicationToken: applicationToken,
	}

	return &chat, nil
}
