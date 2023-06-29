require 'logger'

class AppConfigurator
  def get_token
    ENV.fetch('TELEGRAM_BOT_TOKEN')
  end

  def get_logger
    Logger.new(STDOUT)
  end
end
