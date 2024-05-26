APPLICATIONS_TO_UPDATE_CHATS_COUNTER = "applications_to_update_chats_counter"
REDIS = Redis.new(url: ENV['REDIS_URL'], db: 1)
require Rails.root.join('lib', 'lua_scripts')

class UpdateChatsCounterForApplicationsJob < ApplicationJob
  queue_as :default


  def perform()
    applications_to_update_chats_counter = REDIS.eval(LuaScripts::GET_STALE_COUNTERS_SCRIPT, keys: [APPLICATIONS_TO_UPDATE_CHATS_COUNTER])
    token_counter_map = JSON.parse(applications_to_update_chats_counter)

    batch_update_query = ''
    token_counter_map.each do |token, chats_counter|
      batch_update_query = batch_update_query + "UPDATE applications SET chats_counter = #{chats_counter} WHERE token = '#{token}';"
    end

    ActiveRecord::Base.connection.execute(batch_update_query)
  end
end
