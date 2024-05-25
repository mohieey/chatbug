package services

import (
	"chatbugGo/models"
	"encoding/json"
	"fmt"
	"log"
	"strconv"

	workers "github.com/digitalocean/go-workers2"
	"github.com/go-redis/redis"
)

type MeesageService struct {
	Producer    *workers.Producer
	RedisClient *redis.Client
}

func (m *MeesageService) Enqueue(text string, chatNumber string, applicationToken string) (*models.Message, error) {
	chatNumberInt64, err := strconv.ParseInt(chatNumber, 10, 64)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}

	message := models.Message{
		Number:           m.RedisClient.Incr(fmt.Sprintf("%v:%v", applicationToken, chatNumber)).Val(),
		Text:             text,
		ChatNumber:       chatNumberInt64,
		ApplicationToken: applicationToken,
	}

	messageJsonData, err := json.Marshal(message)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	m.Producer.Enqueue(queueName, createMessageJob, string(messageJsonData))

	return &message, nil
}
