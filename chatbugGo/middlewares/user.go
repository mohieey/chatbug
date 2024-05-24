package middlewares

import (
	"chatbugGo/appctx"
	"chatbugGo/helpers"
	"chatbugGo/services"
	"net/http"
)

func SetUserId(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		token, err := helpers.GetBearerToken(r)
		if err != nil {
			next.ServeHTTP(w, r)
			return
		}

		userId, err := services.Decode(token)
		if err != nil {
			next.ServeHTTP(w, r)
			return
		}

		ctx := r.Context()
		ctx = appctx.WithUserId(ctx, userId)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

func RequireUser(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		err := appctx.UserId(r.Context())
		if err != nil {
			http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
			return
		}

		next.ServeHTTP(w, r)
	})
}
