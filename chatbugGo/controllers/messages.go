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
	text := r.FormValue("text")

	message, err := m.MessageService.Create(text, chatNumber, applicationToken)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(message)
}
