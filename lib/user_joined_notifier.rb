require './lib/member_joined_message_composer'
require './lib/message_subscribed_users'

class UserJoinedNotifier
    attr_reader :update
    attr_reader :bot
    attr_reader :logger

    def initialize(update, bot, logger)
      @update = update
      @bot = bot
      @logger = logger
    end

    def call
      return unless update.instance_of?(Telegram::Bot::Types::ChatMemberUpdated) && update_on_user_joining?

      message = MemberJoinedMessageComposer.new(update).call
      MessageSubscribedUsers.new(update.chat.id, message, bot, logger).call
    end

    private

    def update_on_user_joining?
      new_member = update.new_chat_member
      old_member = update.old_chat_member

      (new_member.user.id == old_member.user.id) &&
        (old_member.status == 'left' && new_member.status == 'member') ||
          (old_member.status == 'kicked' && new_member.status == 'member')
    end
end