require 'logging'

require './lib/database_connector'

class AppConfigurator
  def configure
    setup_database
  end

  def get_token
    ENV.fetch('TELEGRAM_BOT_TOKEN')
  end

  def get_logger(stream_name = 'bot')
    logger = Logging.logger[stream_name]
    layout = Logging.layouts.pattern \
      :pattern      => '[%d] %-5l %c: %m\n',
      :date_pattern => '%Y-%m-%d %H:%M:%S'

    logger.add_appenders \
      Logging.appenders.stdout(layout: layout),
      Logging.appenders.file("logs/#{stream_name}.log", layout: layout)

    logger
  end

  private

  def setup_database
    DatabaseConnector.establish_connection(get_logger('database'))
  end
end
