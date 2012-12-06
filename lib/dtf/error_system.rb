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
