require './models/user'
require './lib/message_sender'

class MessageResponder
  attr_reader :message
  attr_reader :bot
  attr_reader :logger

  def initialize(options, logger)
    @bot = options[:bot]
    @message = options[:message]
    @logger = logger
  end

  def respond
    return unless message.instance_of?(Telegram::Bot::Types::Message)

    @logger.info("Received a message: #{message}")

    on /^\/start group-id-"(.*)"/ do |group_id|
      register_receiver(group_id)
    end

    on /^\/stop/ do
      unregister_receiver
    end
  end

  private

  def register_receiver(group_id)
    User.find_or_create_by!(user_id: message.from.id, group_id: group_id) do |user|
      @logger.info("New link created: user_id – #{user.user_id}, group_id – #{group_id}")
      answer_with_message("You are subscribed to bot's notifications for group #{group_id}! 🎉")
    end
  end

  def unregister_receiver
    links = User.where(user_id: message.from.id)

    unless links.empty?
      groups = links.map(&:group_id)

      links.destroy_all

      answer_with_message("You are unsubscribed from bot's notifications for groups: #{groups}")
    end
  end

  def answer_with_message(text)
    MessageSender.new({ bot: bot, chat_id: message.chat.id, text: text }, logger).send
  end

  def on regex, &block
    regex =~ message.text

    if $~
      case block.arity
      when 0
        yield
      when 1
        yield $1
      when 2
        yield $1, $2
      end
    end
  end
end