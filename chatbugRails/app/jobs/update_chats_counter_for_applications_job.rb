APPLICATIONS_TO_UPDATE_CHATS_COUNTER = "applications_to_update_chats_counter"
require Rails.root.join('lib', 'lua_scripts')

class UpdateChatsCounterForApplicationsJob < ApplicationJob
  queue_as :default


  def perform()
    applications_to_update_chats_counter = REDIS.eval(LuaScripts::GET_STALE_CHATS_COUNTERS_SCRIPT, keys: [APPLICATIONS_TO_UPDATE_CHATS_COUNTER])
    id_counter_map = JSON.parse(applications_to_update_chats_counter)

    batch_update_query = ''
    id_counter_map.each do |id, chats_counter|
      batch_update_query = batch_update_query + "UPDATE applications SET chats_counter = #{chats_counter} WHERE id = '#{id}';"
    end

    if !batch_update_query.empty?
        Rails.logger.info "EXCUTING CHATS_COUNTER UPDATE"
        ActiveRecord::Base.connection.execute(batch_update_query)
    end
  end
end
