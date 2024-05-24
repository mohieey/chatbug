package services

import (
	"os"

	"github.com/golang-jwt/jwt/v5"
)

func Decode(tokenString string) (float64, error) {
	claims := jwt.MapClaims{}
	HMAC_SECRET := os.Getenv("HMAC_SECRET")
	_, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		return []byte(HMAC_SECRET), nil
	})

	userId, ok := claims["user_id"]
	if !ok {
		return -1, err
	}

	return userId.(float64), nil
}
