CHATS_TO_UPDATE_MESSAGES_COUNTER = "chats_to_update_messages_counter"
require Rails.root.join('lib', 'lua_scripts')

class UpdateMessagesCounterForChatsJob < ApplicationJob
  queue_as :default

  def perform()
    chats_to_update_messages_counter = REDIS.eval(LuaScripts::GET_STALE_MESSAGES_COUNTERS_SCRIPT, keys: [CHATS_TO_UPDATE_MESSAGES_COUNTER])
    id_counter_map = JSON.parse(chats_to_update_messages_counter)

    batch_update_query = {}
    id_counter_map.each do |id, messages_counter|
      batch_update_query[id] = { "messages_counter" => messages_counter }
    end

    Rails.logger.info "EXCUTING MESSAGES_COUNTER UPDATE"
    Chat.update(batch_update_query.keys, batch_update_query.values)
  end
end
