module Dtf::Command
  # This sub-command is used to add a User to the Test Framework system
  #
  # Required Parameters are:
  #  --user-name [String], --full-name [String], --email-address [String]
  #
  # '--user-name' is used to specify the user_name of the created User, and *must* be unique in the system.
  # '--full-name' is the Real Name of the created User.
  # '--email-address' is the email address of the created User, and *must* be unique in the system.
  class CreateUser
    def initialize(cmd_name, options)
      @cmd_name = cmd_name
      @cmd_opts = options
    end

    def execute
      if [:user_name_given, :full_name_given, :email_address_given].all? { |sym| @cmd_opts.key?(sym) } then
        user = User.where(user_name:     @cmd_opts[:user_name],
                          full_name:     @cmd_opts[:full_name],
                          email_address: @cmd_opts[:email_address]).create

        # Check to make sure user was actually saved to the db
        if user.persisted? then
          puts "Created user \'#{@cmd_opts[:user_name]}\' for \'#{@cmd_opts[:full_name]}\'"
        else
          # Oops, it wasn't! Notify user and display any error message(s)
          $stderr.puts "ERROR: #{@cmd_opts[:user_name].to_s} was NOT created! Please fix the following errors and try again:"
          user.errors.full_messages.each do |msg|
            $stderr.puts "#{msg}"
          end
          # Now throw a proper error code to the system, while exiting the script
          abort()
        end
      else
        Dtf::ErrorSystem.raise_error(@cmd_name) # This error here is thrown when not all params are provided
      end
    end
  end
end
