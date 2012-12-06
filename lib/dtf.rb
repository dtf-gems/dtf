# encoding: UTF-8

require 'dtf/version'
require 'trollop'

module Dtf
  require_relative 'dtf/error_system.rb'
  load "#{File.join(File.dirname(__FILE__), "/config/environment.rb")}"

  module Command

    require_relative 'dtf/command/setup_dtf.rb'
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

  # Dtf::OptionsParser is DTF's command/options/parameters parsing class.
  # It also doubles as DTF's help system.
  class OptionsParser
    # List of all sub-commands known within the Help System
    SUB_COMMANDS = %w(create_user delete_user create_vs delete_vs setup)

    # ARGV parsing method and options builder. Method depends on Trollop gem.
    #
    # Dynamically builds, and returns, the @cmd_opts Hash based on contents of @cmd,
    # and provides the help system for options/parameters.
    #
    # Returned Values: @cmd [Type: String] and @cmd_opts [Type: Hash]
    def parse_cmds(arg)
      # Global options default to '--version|-v' and '--help|-h'
      global_opts = Trollop::options do
        version "DTF v#{Dtf::VERSION}"
        banner <<-EOS
        #{version}
        (c) Copyright 2012 David Deryl Downey / Deryl R. Doucette. All Rights Reserved.
        This is free software; see the LICENSE file for copying conditions.
        There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

        Usage:
              dtf -v|--version -h|--help [[sub_cmds <options>] -h|--help]

        Valid [sub_cmds] are: create_(user|vs), delete_(user|vs)
        See 'dtf [sub_cmd] -h' for each sub_cmd's details and options

        EOS
        stop_on SUB_COMMANDS
      end

      cmd      = arg.shift
      cmd_opts = case cmd
                   when "create_user"
                     Trollop::options do
                       opt(:user_name, desc="Username for new TF user - REQUIRED", opts={ :type => :string, :short => '-u' })
                       opt(:full_name, desc="Real name for new TF user - REQUIRED", opts={ :type => :string, :short => '-n' })
                       opt(:email_address, desc="Email address for new TF user - REQUIRED", opts={ :type => :string, :short => '-e' })
                     end
                   when "create_vs"
                     Trollop::options do
                       opt(:user_name, desc="TF user to associate this VS with - REQUIRED", opts={ :type => :string, :short => '-u' })
                       opt(:name, desc="Name for new VS - REQUIRED", opts={ :type => :string, :short => '-n' })
                       opt(:description, desc="Description of VS's intended use - OPTIONAL", opts={ :type => :string, :short => '-d', :default => '' })
                     end
                   when "delete_user"
                     Trollop::options do
                       opt(:user_name, desc="Username of TF user to delete - REQUIRED", opts={ :type => :string, :short => '-u' })
                       opt(:delete_all, desc="Delete _all_ VSs this user owns", :type => :flag, :default => true)
                     end
                   when "delete_vs"
                     Trollop::options do
                       opt(:user_name, desc="Username of VS owner - REQUIRED", opts={ :type => :string, :short => '-u' })
                       opt(:id, desc="ID of VS to be deleted - REQUIRED", opts={ :type => :int, :short => '-i' })
                     end
                   when "setup_dtf"
                     Trollop::options do
                       opt(:install, desc="Defines if should install or not", opts={ :type => :flag, :default => true })
                     end
                   when nil
                     Trollop::die "No command specified! Please specify an applicable command"
                   else
                     Trollop::die "Unknown DTF sub-command: #{@cmd.inspect}"
                 end

      return cmd, cmd_opts # Explicitly return cmd and its cmd_opts
    end
  end

end # End of Dtf module
