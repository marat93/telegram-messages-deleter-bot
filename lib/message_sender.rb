require 'byebug'

class MessageSender
  attr_reader :bot
  attr_reader :text
  attr_reader :chat_id
  attr_reader :logger

  def initialize(options, logger)
    @bot = options[:bot]
    @text = options[:text]
    @chat_id = options[:chat_id]
    @logger = logger
  end

  def send
    bot.api.send_message(chat_id: chat_id, text: text, parse_mode: 'Markdown')

    @logger.debug "sending '#{text}' to #{chat_id}"
  end
end