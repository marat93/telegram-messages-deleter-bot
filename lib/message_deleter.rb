class MessageDeleter
  attr_reader :bot
  attr_reader :message_to_delete
  attr_reader :logger

  def initialize(message_to_delete, bot, logger)
    @bot = bot
    @message_to_delete = message_to_delete
    @logger = logger
  end

  def delete
    return unless message_to_delete.instance_of?(Telegram::Bot::Types::Message) && message_to_delete.new_chat_members

    message_to_delete.new_chat_members.each do |new_member|
      delete_message(new_member)
      MessageSubscribedUsers.new(message_to_delete.chat.id, message("message_deleted.successfully", message_to_delete, new_member), bot, logger).call
    rescue Telegram::Bot::Exceptions::ResponseError => e
      logger.error("Error when deleting the message: #{e.message}")
      MessageSubscribedUsers.new(message_to_delete.chat.id, message("message_deleted.unsuccessfully", message_to_delete, new_member), bot, logger).call
    end
  end

  private

  def delete_message(new_member)
    logger.debug("Deleting message ##{message_to_delete.message_id} about #{new_member.first_name} #{new_member.last_name} (@#{new_member.username}) joining the group")
    bot.api.delete_message(chat_id: message_to_delete.chat.id, message_id: message_to_delete.message_id)
    logger.info("Message ##{message_to_delete.message_id} deleted")
  end

  def message(i18n_key, deleted_message, joined_user)
    I18n.t(i18n_key,
           message_id: deleted_message.message_id,
           user_name: user_full_name(joined_user),
           user_id: joined_user.id,
           chat_name: deleted_message.chat.title)
  end

  def user_full_name(user)
    # unnecessary space left when last name is missing when using interpolation to concatenate these strings
    [user.first_name, user.last_name].compact.join(' ')
  end
end
