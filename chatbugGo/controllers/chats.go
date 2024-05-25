package controllers

import (
	"chatbugGo/services"
	"encoding/json"
	"net/http"

	"github.com/go-chi/chi/v5"
)

type Chats struct {
	ChatService *services.ChatService
}

func (c *Chats) Create(w http.ResponseWriter, r *http.Request) {
	applicationToken := chi.URLParam(r, "application_token")

	chat, err := c.ChatService.Enqueue(applicationToken)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(chat)
}
