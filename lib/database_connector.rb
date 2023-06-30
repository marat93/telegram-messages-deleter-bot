require 'active_record'

class DatabaseConnector
  class << self
    def establish_connection(logger)
      ActiveRecord::Base.logger = logger

      configuration = YAML::load(IO.read(database_config_path))

      ActiveRecord::Base.establish_connection(configuration)
    end

    private

    def database_config_path
      'config/database.yml'
    end
  end
end