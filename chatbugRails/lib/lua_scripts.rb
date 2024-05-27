module LuaScripts
  GET_STALE_CHATS_COUNTERS_SCRIPT = <<-LUA
    local zset_name = KEYS[1]
    local map = {}

    -- Get the current time in seconds
    local current_time = redis.call('TIME')
    local current_timestamp = tonumber(current_time[1])
    local cutoff_timestamp = current_timestamp - 3300  -- 55 minutes in seconds

    -- Get the members with a timestamp older than 30 minutes
    local members = redis.call('ZRANGEBYSCORE', zset_name, '-inf', cutoff_timestamp)

    -- Remove these members from the sorted set
    redis.call('ZREMRANGEBYSCORE', zset_name, '-inf', cutoff_timestamp)

    -- Add them back with the new timestamp and populate the map
    for i, member in ipairs(members) do
        redis.call('ZADD', zset_name, current_timestamp, member)
        local id = redis.call('HGET', 'apps_tokens_to_apps_ids', member)
        map[id] = redis.call('GET', member)
    end

    -- Serialize the map table to JSON
    local serialized_map = cjson.encode(map)

    -- Return the serialized map
    return serialized_map
  LUA

  GET_STALE_MESSAGES_COUNTERS_SCRIPT = <<-LUA
    local zset_name = KEYS[1]
    local map = {}

    -- Get the current time in seconds
    local current_time = redis.call('TIME')
    local current_timestamp = tonumber(current_time[1])
    local cutoff_timestamp = current_timestamp - 3300  -- 55 minutes in seconds

    -- Get the members with a timestamp older than 30 minutes
    local members = redis.call('ZRANGEBYSCORE', zset_name, '-inf', cutoff_timestamp)

    -- Remove these members from the sorted set
    redis.call('ZREMRANGEBYSCORE', zset_name, '-inf', cutoff_timestamp)

    -- Add them back with the new timestamp and populate the map
    for i, member in ipairs(members) do
        redis.call('ZADD', zset_name, current_timestamp, member)
        local id = redis.call('HGET', 'chats_token_and_number_to_chats_ids', member)
        map[id] = redis.call('GET', member)
    end

    -- Serialize the map table to JSON
    local serialized_map = cjson.encode(map)

    -- Return the serialized map
    return serialized_map
  LUA
end
