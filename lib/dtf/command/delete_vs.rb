module Dtf::Command
  # This sub-command removes a Verification Suite from the Testing Framework system
  #
  # Required Parameters are:
  #  --user-name [String], --id [Integer]
  #
  # The '--user-name' parameter is the user_name of the User that owns the Verification Suite you wish to delete
  # The '--id' parameter is the ID # of the Verification Suite you wish to delete, as provided by @vs.id
  class DeleteVs
    def initialize(cmd_name, options)
      @cmd_name = cmd_name
      @cmd_opts = options
    end

    def execute
      if [:user_name_given, :id_given].all? { |sym| @cmd_opts.key?(sym) } then
        puts "Deleting #{@cmd_opts[:user_name]}\'s VS with ID \'#{@cmd_opts[:id]}\'"
        user = User.find_by_user_name(@cmd_opts[:user_name])
        vs   = user.verification_suites.find(@cmd_opts[:id])
        VerificationSuite.delete(vs)
      else
        Dtf::ErrorSystem.raise_error(@cmd_name)
      end
    end
  end
end
