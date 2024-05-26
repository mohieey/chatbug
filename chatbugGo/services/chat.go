package services

import (
	"chatbugGo/models"
	"encoding/json"
	"log"
	"strconv"

	workers "github.com/digitalocean/go-workers2"
	"github.com/go-redis/redis"
)

type ChatService struct {
	Producer    *workers.Producer
	RedisClient *redis.Client
}

func (c *ChatService) EnqueueCreate(applicationToken, chatName string) (*models.Chat, error) {
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

func (c *ChatService) EnqueueUpdate(applicationToken string, chatNumber string, chatName string) (*models.Chat, error) {
	chatNumberInt64, err := strconv.ParseInt(chatNumber, 10, 64)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}

	chat := models.Chat{
		Number:           chatNumberInt64,
		Name:             chatName,
		ApplicationToken: applicationToken,
	}

	chatJsonData, err := json.Marshal(chat)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	c.Producer.Enqueue(queueName, updateChatJob, string(chatJsonData))

	return &chat, nil
}
