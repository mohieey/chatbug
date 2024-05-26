package controllers

import (
	"chatbugGo/services"
	"encoding/json"
	"net/http"

	"github.com/go-chi/chi/v5"
)

type Messages struct {
	MessageService *services.MeesageService
}

func (m *Messages) Create(w http.ResponseWriter, r *http.Request) {
	applicationToken := chi.URLParam(r, "application_token")
	chatNumber := chi.URLParam(r, "chat_number")
	body := r.FormValue("body")

	message, err := m.MessageService.EnqueueCreate(body, chatNumber, applicationToken)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(message)
}

func (m *Messages) Update(w http.ResponseWriter, r *http.Request) {
	applicationToken := chi.URLParam(r, "application_token")
	chatNumber := chi.URLParam(r, "chat_number")
	messageNumber := chi.URLParam(r, "message_number")
	body := r.FormValue("body")

	_, err := m.MessageService.EnqueueUpdate(body, messageNumber, chatNumber, applicationToken)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusNoContent)
}
