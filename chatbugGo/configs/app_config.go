package configs

import (
	"fmt"
	"os"
	"strconv"

	"github.com/lpernett/godotenv"
)

type Config struct {
	Redis struct {
		Addr     string
		Password string
		DB       int
	}

	SidekiqProducer struct {
		ServerAddr string
		Database   int
		PoolSize   int
		ProcessId  string
	}

	Server struct {
		Host string
		Port string
	}
}

func loadRedisConfig(config *Config) error {
	config.Redis.Addr = os.Getenv("REDIS_HOST")
	config.Redis.Password = os.Getenv("REDIS_PASSWORD")
	DB, err := strconv.Atoi((os.Getenv("REDIS_DB")))
	if err != nil {
		return err
	}
	config.Redis.DB = DB

	return nil
}

func loadSidekiqProducerConfig(config *Config) error {
	config.SidekiqProducer.ServerAddr = os.Getenv("SIDEKIQ_REDIS_HOST")
	DB, err := strconv.Atoi((os.Getenv("SIDEKIQ_REDIS_DB")))
	if err != nil {
		return err
	}
	config.SidekiqProducer.Database = DB

	poolSize, err := strconv.Atoi((os.Getenv("SIDEKIQ_REDIS_POOLSIZE")))
	if err != nil {
		return err
	}
	config.SidekiqProducer.PoolSize = poolSize
	config.SidekiqProducer.ProcessId = os.Getenv("SIDEKIQ_PROCESSID")

	return nil
}

func loadServerConfig(config *Config) {
	config.Server.Host = os.Getenv("HOST")
	config.Server.Port = os.Getenv("PORT")
}

func LoadEnvConfig() (*Config, error) {
	err := godotenv.Load()
	if err != nil {
		return nil, fmt.Errorf("error loading environment configuration file: %v", err)
	}

	var config Config

	err = loadRedisConfig(&config)
	if err != nil {
		return nil, fmt.Errorf("error loading redis configurations: %v", err)
	}

	err = loadSidekiqProducerConfig(&config)
	if err != nil {
		return nil, fmt.Errorf("error loading sidekiq producer configurations: %v", err)
	}

	loadServerConfig(&config)

	return &config, nil
}
