package main

import (
	"chatbugGo/controllers"
	"chatbugGo/middlewares"
	"chatbugGo/services"
	"fmt"
	"net/http"
	"os"

	"github.com/go-chi/chi/v5"
	"github.com/lpernett/godotenv"
)

type config struct {
	Server struct {
		Host string
		Port string
	}
}

func loadEnvConfig() (*config, error) {
	err := godotenv.Load()
	if err != nil {
		return nil, fmt.Errorf("error loading environment configuration file: %v", err)
	}

	var config config

	config.Server.Host = os.Getenv("HOST")
	config.Server.Port = os.Getenv("PORT")

	return &config, nil
}

func main() {
	cfg, err := loadEnvConfig()
	if err != nil {
		panic(err)
	}

	// Setup services
	chatService := services.ChatService{}

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
