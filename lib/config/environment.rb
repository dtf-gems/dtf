# encoding: UTF-8

# Application wide requirements
require 'active_record'
require 'active_model'
require 'active_support'
require 'multi_json'
require 'sqlite3'
require 'yaml'
require 'logger'
require 'thor'

# NOTE: Set RAILS_ENV to 'production' for ActiveRecord. Affects the database to use.
# Change this to 'development' while working on the gem itself, or set it in the
# environment prefixed to commands, in order to gain access to testing gems.
# NOTE: Set RAILS_ENV to 'production' for ActiveRecord. Affects the database to use.
# Change this to 'development' while working on the gem itself, or set it in the
# environment prefixed to commands, in order to gain access to testing gems.
ENV['RAILS_ENV'] ||= 'development'

# Load the db config and create a connectoid. Make an ivar so its shared throughout the application
if ENV['RAILS_ENV'] == 'test' then
  ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
  puts "NOTICE: Loading db schema to IN-MEMORY SQLite3 db"
  load "#{File.join(File.dirname(__FILE__), '../../db/schema.rb')}"
else
  @dbconfig = YAML::load(File.open(File.join(File.dirname(__FILE__), '../../db/config.yml')))[ENV['RAILS_ENV']]
  # Establish the database connection
  puts "NOTICE: Loading db schema to ON-DISK SQLite3 db"
  ActiveRecord::Base.establish_connection(@dbconfig) # Line that actually connects the db.
end

# Load all the models
Dir["#{File.join(File.dirname(__FILE__), '../../app/models/*.rb')}"].each do |model|
  load "#{model}"
end

