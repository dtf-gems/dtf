# encoding: UTF-8

require 'dtf/version'
require 'trollop'

module Dtf
  load "#{File.join(File.dirname(__FILE__), "/config/environment.rb")}"

  module Command
    def self.create_cmd(cmd)
      puts "#{@cmd}"
      begin
        new_cmd = Dtf::Command.const_get(cmd.camelize).new
      rescue NameError
        puts "DTF has no registered command by that name."
        puts "Please see 'dtf -h' for the list of recognized commands."
      else
        return new_cmd
      end
    end

    # This sub-command is used to add a User to the Test Framework system
    #
    # Required Parameters are:
    #  --user-name [String], --full-name [String], --email-address [String]
    #
    # '--user-name' is used to specify the user_name of the created User, and *must* be unique in the system.
    # '--full-name' is the Real Name of the created User.
    # '--email-address' is the email address of the created User, and *must* be unique in the system.
    class CreateUser
      def execute(cmd_opts)
        if [:user_name_given, :full_name_given, :email_address_given].all? { |sym| cmd_opts.key?(sym) } then
          user = User.where(user_name:     cmd_opts[:user_name],
                             full_name:     cmd_opts[:full_name],
                             email_address: cmd_opts[:email_address]).create

          # Check to make sure user was actually saved to the db
          if user.persisted? then
            puts "Created user \'#{cmd_opts[:user_name]}\' for \'#{cmd_opts[:full_name]}\'"
          else
            # Oops, it wasn't! Notify user and display any error message(s)
            $stderr.puts "ERROR: #{cmd_opts[:user_name].to_s} was NOT created! Please fix the following errors and try again:"
            user.errors.full_messages.each do |msg|
              $stderr.puts "#{msg}"
            end
            # Now throw a proper error code to the system, while exiting the script
            abort()
          end
        else
          Dtf::ErrorSystem.raise_error(@cmd) # This error here is thrown when not all params are provided
        end
      end
    end

    # This sub-command generates, adds, and associates a Verification Suite in the Testing Framework system.
    #
    # Required Parameters are:
    #  --user-name [String], --name [String]
    #
    # '--user-name' is the user_name of the User that should own this Verification Suite.
    # '--name' is the descriptive name of the Verification Suite.
    #
    # Options are:
    #  --description [String]
    #
    # This *optional* parameter is for providing a description of the Verification Suite's use.
    # e.g. --description "RSpec Verification"
    class CreateVs
      def execute(cmd_opts)
        if [:user_name_given, :name_given].all? { |sym| cmd_opts.key?(sym) } then
          user = User.find_by_user_name(cmd_opts[:user_name])
          vs   = user.verification_suites.create(name: cmd_opts[:name], description: cmd_opts[:description])
          if vs.persisted? then
            puts "VS named \'#{cmd_opts[:name]}\' allocated to user \'#{cmd_opts[:user_name]}\'"
          else
            $stderr.puts "ERROR: Failed to save Verification Suite. Check DB logfile for errors"
            abort()
          end
        else
          Dtf::ErrorSystem.raise_error(@cmd)
        end
      end
    end

    # This sub-command removes a User from the Testing Framework system
    #
    # Required Parameters are:
    #  --user-name [String]
    #
    # '--user-name' is the assigned user_name of the User you wish to delete.
    #
    # Optional Flags are:
    #  --delete-all|--no-delete-all
    #
    # By default this command will delete *all* Verification Suites owned by the deleted user.
    # The default behaviour is as if the sub-command had been invoked passing the '--delete-all' flag explicitly.
    #
    # To delete the user, but *keep* their VS, pass the '--no-delete-all' flag.
    # This flag will find all Verification Suites owned by the user being deleted, and reassign them
    # to 'Library Owner' (user_name: library_owner) which is the generic in-house User shipped with DTF.
    class DeleteUser
      def execute(cmd_opts)
        if [:user_name_given, :delete_all].all? { |sym| cmd_opts.key?(sym) } then
          # NOTE: :delete_all is 'true' by default. passing '--no-delete-all' sets it to false,
          # and adds the :delete_all_given key to the cmd_opts hash, set to true.
          # This means NOT to delete all VSs associated with this user. We delete them by default.
          if cmd_opts[:delete_all] == false && cmd_opts[:delete_all_given] == true
            puts "Called with '--no-delete-all' set! NOT deleting all owned VSs!"
            puts "Reassigning VSs to Library. New owner will be \'Library Owner\'"
            user      = User.find_by_user_name(cmd_opts[:user_name])
            lib_owner = User.find_by_user_name("library_owner")
            user.verification_suites.all.each do |vs|
              vs.user_id = lib_owner.id
              vs.save
            end
            User.delete(user)
          else
            puts "Called with '--delete-all' set or on by default! Deleting all VSs owned by #{cmd_opts[:user_name]}"
            user = User.find_by_user_name(cmd_opts[:user_name])
            if ! user.nil? then
              user.verification_suites.all.each do |vs|
                VerificationSuite.delete(vs)
              end
              if user.verification_suites.empty? then
                User.delete(user)
              end
            else
              $stderr.puts "ERROR: No user named \'#{cmd_opts[:user_name].to_s}\' found!"
              abort()
            end
          end
        else
          Dtf::ErrorSystem.raise_error(@cmd)
        end
      end
    end

    # This sub-command removes a Verification Suite from the Testing Framework system
    #
    # Required Parameters are:
    #  --user-name [String], --id [Integer]
    #
    # The '--user-name' parameter is the user_name of the User that owns the Verification Suite you wish to delete
    # The '--id' parameter is the ID # of the Verification Suite you wish to delete, as provided by @vs.id
    class DeleteVs
      def execute(cmd_opts)
        if [:user_name_given, :id_given].all? { |sym| cmd_opts.key?(sym) } then
          puts "Deleting #{cmd_opts[:user_name]}\'s VS with ID \'#{cmd_opts[:id]}\'"
          user = User.find_by_user_name(cmd_opts[:user_name])
          vs   = user.verification_suites.find(cmd_opts[:id])
          VerificationSuite.delete(vs)
        else
          Dtf::ErrorSystem.raise_error(@cmd)
        end
      end
    end

  end # End of Dtf::Command module

  # Dtf::ErrorSystem is DTF's custom error management class
  class ErrorSystem
    # Reusable error raising and response method.
    # Returns exit status code of '1' via abort().
    def self.raise_error(cmd)
      $stderr.puts "ERROR! #{cmd} did not receive all required options."
      $stderr.puts "Please execute \'dtf #{cmd} -h\' for more information."
      abort()
    end

    # Reusable object error display method.
    #
    # Takes an Object as arg and displays that Object's full error messages.
    # Will return the @user object's full error messages, 1 per line.
    #
    # Example usage: Dtf::ErrorSystem.display_errors(@user)
    def self.display_errors(obj)
      # TODO: Refactor error display to take sub-command as an arg
      # and display obj.errors.full_messages.each properly for each arg type.
      obj.errors.full_messages.all.each do |msg|
        $stderr.puts "#{msg}"
      end
    end
  end

  # Dtf::OptionsParser is DTF's command/options/parameters parsing class.
  # It also doubles as DTF's help system.
  class OptionsParser
    # List of all sub-commands known within the Help System
    SUB_COMMANDS = %w(create_user delete_user create_vs delete_vs)

    # ARGV parsing method and options builder. Method depends on Trollop gem.
    #
    # Dynamically builds, and returns, the @cmd_opts Hash based on contents of @cmd,
    # and provides the help system for options/parameters.
    #
    # Returned Values: @cmd [Type: String] and @cmd_opts [Type: Hash]
    def parse_cmds(arg=ARGV)
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

      @cmd = arg.shift
      @cmd_opts = case @cmd
      when "create_user"
        Trollop::options do
          opt(:user_name, desc="Username for new TF user - REQUIRED", opts={:type => :string, :short => '-u'})
          opt(:full_name, desc="Real name for new TF user - REQUIRED", opts={:type => :string, :short => '-n'})
          opt(:email_address, desc="Email address for new TF user - REQUIRED", opts={:type => :string, :short => '-e'})
        end
      when "create_vs"
        Trollop::options do
          opt(:user_name, desc="TF user to associate this VS with - REQUIRED", opts={:type => :string, :short => '-u'})
          opt(:name, desc="Name for new VS - REQUIRED", opts={:type => :string, :short => '-n'})
          opt(:description, desc="Description of VS's intended use - OPTIONAL", opts={:type => :string, :short => '-d', :default => ''})
        end
      when "delete_user"
        Trollop::options do
          opt(:user_name, desc="Username of TF user to delete - REQUIRED", opts={:type => :string, :short => '-u'})
          opt(:delete_all, desc="Delete _all_ VSs this user owns", :type => :flag, :default => true)
        end
      when "delete_vs"
        Trollop::options do
          opt(:user_name, desc="Username of VS owner - REQUIRED", opts={:type => :string, :short => '-u'})
          opt(:id, desc="ID of VS to be deleted - REQUIRED", opts={:type => :int, :short => '-i'})
        end
      when nil
        Trollop::die "No command specified! Please specify an applicable command"
      else
        Trollop::die "Unknown DTF sub-command: #{@cmd.inspect}"
      end

      return @cmd, @cmd_opts # Explicitly return @cmd and its @cmd_opts
    end
  end

end # End of Dtf module
