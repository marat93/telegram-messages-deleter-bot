require 'logging'

class AppConfigurator
  def get_token
    ENV.fetch('TELEGRAM_BOT_TOKEN')
  end

  def get_logger
    logger = Logging.logger['Bot']
    layout = Logging.layouts.pattern \
      :pattern      => '[%d] %-5l %c: %m\n',
      :date_pattern => '%Y-%m-%d %H:%M:%S'

    logger.add_appenders \
      Logging.appenders.stdout(layout: layout),
      Logging.appenders.file('logs/bot.log', layout: layout)

    logger
  end
end
