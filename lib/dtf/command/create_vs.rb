module Dtf::Command
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
    def initialize(cmd_name, options)
      @cmd_name = cmd_name
      @cmd_opts = options
    end

    def execute
      if [:user_name_given, :name_given].all? { |sym| @cmd_opts.key?(sym) } then
        user = User.find_by_user_name(@cmd_opts[:user_name])
        vs   = user.verification_suites.create(name: @cmd_opts[:name], description: @cmd_opts[:description])
        if vs.persisted? then
          puts "VS named \'#{@cmd_opts[:name]}\' allocated to user \'#{@cmd_opts[:user_name]}\'"
        else
          $stderr.puts "ERROR: Failed to save Verification Suite. Check DB logfile for errors"
          abort()
        end
      else
        Dtf::ErrorSystem.raise_error(@cmd_name)
      end
    end
  end
end
