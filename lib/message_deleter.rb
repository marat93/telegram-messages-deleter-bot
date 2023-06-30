class MessageDeleter
    attr_reader :bot
    attr_reader :message
    attr_reader :logger

    def initialize(options, logger)
      @bot = options[:bot]
      @message = options[:message]
      @logger = logger
    end

    def delete
      return unless message.instance_of?(Telegram::Bot::Types::Message) && message.new_chat_members

      message.new_chat_members.each do |new_member|
          delete_message(new_member)
      end
    rescue Telegram::Bot::Exceptions::ResponseError => e
      logger.error("Error when deleting the message: #{e.message}")
    end

    private

    def delete_message(new_member)
      logger.debug("Deleting message ##{message.message_id} about #{new_member.first_name} #{new_member.last_name} (@#{new_member.username}) joining the group")
      bot.api.delete_message(chat_id: message.chat.id, message_id: message.message_id)
      logger.info("Message ##{message.message_id} deleted")
    end
  end
