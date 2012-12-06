# encoding: UTF-8

require 'dtf/version'
require 'trollop'

module Dtf
  load "#{File.join(File.dirname(__FILE__), "/config/environment.rb")}"
  require_relative 'dtf/error_system'
  require_relative 'dtf/options_parser'

  module Command

    require_relative 'dtf/command/setup_dtf'
    require_relative 'dtf/command/create_user'
    require_relative 'dtf/command/delete_user'
    require_relative 'dtf/command/create_vs'
    require_relative 'dtf/command/delete_vs'

    def self.create_cmd(cmd, options)
      Dtf::Command.const_get(cmd.camelize).new(cmd, options)
    rescue NameError
      puts "DTF has no registered command by that name."
      puts "Please see 'dtf -h' for the list of recognized commands."
    end

  end # End of Dtf::Command module

end # End of Dtf module
