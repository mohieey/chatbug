package services

import (
	"chatbugGo/models"
	"encoding/json"
	"log"

	workers "github.com/digitalocean/go-workers2"
	"github.com/go-redis/redis"
)

type ChatService struct {
	Producer    *workers.Producer
	RedisClient *redis.Client
}

func (c *ChatService) Enqueue(applicationToken, chatName string) (*models.Chat, error) {
	chat := models.Chat{
		Number:           c.RedisClient.Incr(applicationToken).Val(),
		Name:             chatName,
		ApplicationToken: applicationToken,
	}

	chatJsonData, err := json.Marshal(chat)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	c.Producer.Enqueue(queueName, createChatJob, string(chatJsonData))

	return &chat, nil
}
