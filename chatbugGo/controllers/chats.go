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
	chatName := r.FormValue("name")

	chat, err := c.ChatService.EnqueueCreate(applicationToken, chatName)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(chat)
}

func (c *Chats) Update(w http.ResponseWriter, r *http.Request) {
	applicationToken := chi.URLParam(r, "application_token")
	chatNumber := chi.URLParam(r, "chat_number")
	chatName := r.FormValue("name")

	chat, err := c.ChatService.EnqueueUpdate(applicationToken, chatNumber, chatName)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusNoContent)
	json.NewEncoder(w).Encode(chat)
}
