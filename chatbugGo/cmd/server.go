package main

import (
	"chatbugGo/configs"
	"chatbugGo/controllers"
	"chatbugGo/middlewares"
	"chatbugGo/services"
	"fmt"
	"net/http"

	workers "github.com/digitalocean/go-workers2"
	"github.com/go-chi/chi/v5"
	"github.com/go-redis/redis"
)

func main() {
	cfg, err := configs.LoadEnvConfig()
	if err != nil {
		panic(err)
	}

	// Setup sidekiq producer
	producer, err := workers.NewProducer(workers.Options{
		ServerAddr: cfg.SidekiqProducer.ServerAddr,
		Database:   cfg.SidekiqProducer.Database,
		PoolSize:   cfg.SidekiqProducer.PoolSize,
		ProcessID:  cfg.SidekiqProducer.ProcessId,
	})
	if err != nil {
		panic(err)
	}

	// Setup Redis client
	rdb := redis.NewClient(&redis.Options{
		Addr:     cfg.Redis.Addr,
		Password: cfg.Redis.Password,
		DB:       cfg.Redis.DB,
	})

	// Setup services
	chatService := services.ChatService{
		Producer:    producer,
		RedisClient: rdb,
	}

	// Setup controllers
	chatsController := controllers.Chats{
		ChatService: &chatService,
	}

	// Setup routes
	r := chi.NewRouter()
	r.Use(middlewares.SetUserId)
	r.Use(middlewares.RequireUser)

	r.Group(func(r chi.Router) {
		r.Route("/applications/{application_token}", func(r chi.Router) {
			r.Route("/chats", func(r chi.Router) {
				r.Post("/create", chatsController.Create)
			})
		})
	})

	r.NotFound(func(w http.ResponseWriter, r *http.Request) {
		http.Error(w, "Not Found", http.StatusNotFound)
	})

	address := fmt.Sprintf("%v:%v", cfg.Server.Host, cfg.Server.Port)
	fmt.Println("Serving on ", address)
	err = http.ListenAndServe(address, r)
	if err != nil {
		panic(err)
	}
}
