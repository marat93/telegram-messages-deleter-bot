require 'logger'
require 'yaml'

class AppConfigurator
  def get_token
    YAML::load(IO.read('config/secrets.yml'))['telegram_bot_token']
  end

  def get_logger
    Logger.new(STDOUT)
  end
end
