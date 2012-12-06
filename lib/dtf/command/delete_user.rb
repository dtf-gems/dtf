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
  def initialize(cmd_name, options)
    @cmd_name = cmd_name
    @cmd_opts = options
  end

  def execute
    if [:user_name_given, :delete_all].all? { |sym| @cmd_opts.key?(sym) } then
      # NOTE: :delete_all is 'true' by default. passing '--no-delete-all' sets it to false,
      # and adds the :delete_all_given key to the cmd_opts hash, set to true.
      # This means NOT to delete all VSs associated with this user. We delete them by default.
      if @cmd_opts[:delete_all] == false && @cmd_opts[:delete_all_given] == true
        puts "Called with '--no-delete-all' set! NOT deleting all owned VSs!"
        puts "Reassigning VSs to Library. New owner will be \'Library Owner\'"
        user      = User.find_by_user_name(@cmd_opts[:user_name])
        lib_owner = User.find_by_user_name("library_owner")
        user.verification_suites.all.each do |vs|
          vs.user_id = lib_owner.id
          vs.save
        end
        User.delete(user)
      else
        puts "Called with '--delete-all' set or on by default! Deleting all VSs owned by #{@cmd_opts[:user_name]}"
        user = User.find_by_user_name(@cmd_opts[:user_name])
        if ! user.nil? then
          user.verification_suites.all.each do |vs|
            VerificationSuite.delete(vs)
          end
          if user.verification_suites.empty? then
            User.delete(user)
          end
        else
          $stderr.puts "ERROR: No user named \'#{@cmd_opts[:user_name].to_s}\' found!"
          abort()
        end
      end
    else
      Dtf::ErrorSystem.raise_error(@cmd_name)
    end
  end
end
