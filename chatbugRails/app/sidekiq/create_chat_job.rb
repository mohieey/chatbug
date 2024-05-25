class CreateChatJob
  include Sidekiq::Job

  def perform(args)
    puts "PROCESSING: "
    puts args
  end
end
