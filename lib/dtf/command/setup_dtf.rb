module Dtf::Command
  # Copies Thor task(s) into any project which require's the DTF master gem (this gem)
  # and then calls 'setup_dtf' sub-command.
  # e.g bundle exec dtf setup_dtf
  class SetupDtf
    def initialize(cmd_name, options)
      @cmd_name = cmd_name
      @cmd_opts = options
    end

    def execute
      if "#{Gem.loaded_specs['dtf'].gem_dir}" == "#{Dir.pwd}"
        $stderr.puts "Copying files over themselves is not usually good. Aborting!"
        abort()
      elsif ! File.exists?("#{Dir.pwd}/lib/tasks/setup.thor")
        puts "Installing DTF tasks"
        FileUtils.cp(Dir.glob("#{File.join("#{Gem.loaded_specs['dtf'].gem_dir}", 'lib/tasks/*')}"), "#{Dir.pwd}/lib/tasks/")
      else
        $stderr.puts "Copying files over themselves is not usually good. Aborting!"
        abort()
      end
    end
  end
end
