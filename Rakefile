require 'rubygems'
require 'bundler/setup'

require 'active_record'
require 'yaml'

namespace :db do
  def db_config
    connection.db_config
  end

  def connection
    connection_details = YAML::load(File.open('config/database.yml'))
    @connection ||= ActiveRecord::Base.establish_connection(connection_details)
  end

  desc "Migrate the database"
  task :migrate do
    connection
    ActiveRecord::MigrationContext.new('db/migrate').migrate
    Rake::Task["db:schema"].invoke
  end

  desc 'Create a db/schema.rb file that is portable against any DB supported by AR'
  task :schema do
    ActiveRecord::Tasks::DatabaseTasks.db_dir = './db'
    ActiveRecord::Tasks::DatabaseTasks.dump_schema(db_config)
  end
end
