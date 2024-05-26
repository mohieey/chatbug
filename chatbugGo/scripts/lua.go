package scripts

var GetCounter = `
	local counter_key = KEYS[1]
	local zset_key = KEYS[2]
	local counter_value = redis.call('INCR', counter_key)

	local current_time = redis.call('TIME')
	local current_timestamp = tonumber(current_time[1])
	redis.call('ZADD', zset_key, 'NX', current_timestamp, counter_key)

	return tonumber(counter_value)
`
