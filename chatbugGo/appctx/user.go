package appctx

import (
	"context"
	"errors"
)

type key string

const (
	userIdKey key = "userId"
)

func WithUserId(ctx context.Context, userId float64) context.Context {
	return context.WithValue(ctx, userIdKey, userId)
}

func UserId(ctx context.Context) error {
	_, ok := ctx.Value(userIdKey).(float64)
	if !ok {
		return errors.New("unuthorized user")
	}

	return nil
}
