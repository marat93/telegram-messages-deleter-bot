class MessageSubscribedUsers
  attr_reader :chat_id
  attr_reader :text
  attr_reader :bot
  attr_reader :logger

  def initialize(chat_id, text, bot, logger)
    @bot = bot
    @chat_id = chat_id
    @text = text
    @logger = logger
  end

  def call
    users_to_notify.each do |user|
      MessageSender.new({ bot: bot, chat_id: user.user_id, text: text }, logger).send
    end
  end

  private

  def users_to_notify
    @users ||= User.where(group_id: chat_id)
  end
end
