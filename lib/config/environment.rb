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
ENV['RAILS_ENV'] ||= 'development'

# Load the db config and create a connectoid. Make an ivar so its shared throughout the application
@dbconfig = YAML::load(File.open(File.join(File.dirname(__FILE__), '../../db/config.yml')))[ENV['RAILS_ENV']]

# Establish the database connection
ActiveRecord::Base.establish_connection(@dbconfig) # Line that actually connects the db.

# Load all the models
Dir["#{File.join(File.dirname(__FILE__), '../../app/models/*.rb')}"].each do |model|
  load "#{model}"
end

