FROM golang:1.22-alpine

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build ./cmd/server.go

EXPOSE 3001

CMD ["./server"]
