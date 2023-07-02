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
        notify_subscribed_users_on_success(new_member)
      rescue Telegram::Bot::Exceptions::ResponseError => e
        logger.error("Error when deleting the message: #{e.message}")
        notify_subscribed_users_on_fail(new_member)
      end
    end

    private

    def users_to_notify
      @users ||= User.where(group_id: message.chat.id)
    end

    def delete_message(new_member)
      logger.debug("Deleting message ##{message.message_id} about #{new_member.first_name} #{new_member.last_name} (@#{new_member.username}) joining the group")
      bot.api.delete_message(chat_id: message.chat.id, message_id: message.message_id)
      logger.info("Message ##{message.message_id} deleted")
    end

    def notify_subscribed_users_on_success(new_member)
      users_to_notify.each do |user|
        message_user(user, "✅ Deleted message ##{message.message_id} about #{new_member.first_name} #{new_member.last_name} (@#{new_member.username}) joining the group '#{message.chat.title}'")
      end
    end

    def notify_subscribed_users_on_fail(new_member)
      users_to_notify.each do |user|
        message_user(user, "🚨 Couldn't delete message ##{message.message_id} about #{new_member.first_name} #{new_member.last_name} (@#{new_member.username}) joining the group '#{message.chat.title}'")
      end
    end

    def message_user(user, text)
      MessageSender.new({ bot: bot, chat_id: user.user_id, text: text }, logger).send
    end
  end
