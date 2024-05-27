REDIS = Redis.new(url: ENV['REDIS_URL'], db: 1)
APPS_TOKENS_TO_APPS_IDS_MAP_KEY = "apps_tokens_to_apps_ids"
CHATS_TOKEN_AND_NUMBER_TO_CHATS_IDS_MAP_KEY = "chats_token_and_number_to_chats_ids"
