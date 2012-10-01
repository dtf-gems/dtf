# encoding: UTF-8

class DtfSetup < Thor
  
  desc "install", "Installs DTF core database migrations"
  method_options :force => :boolean
  def install(name= "*")
    puts "Installing db migrations, main schema, and config files"
    
    # The gem is installed elsewhere so the copy path needs to be
    # relative to the gem, not the user. Gem.loaded_specs['dtf'].gemdir
    # tells us where the DTF master gem lives and we need to build up the from location
    # based off that, then copy locally relative to the user.
    # 
    from_dir = "#{File.join("#{Gem.loaded_specs['dtf'].gem_dir}", 'db/migrate')}"
    
    Dir["#{from_dir}/#{name}"].each do |source|

      # Use File.basename to remove the gem's path info so we can
      # use just the filename to copy relative to the user.
      destination = "#{Dir.pwd}/db/migrate/#{File.basename(source)}"

      FileUtils.rm(destination) if options[:force] && File.exist?(destination)
      if File.exist?(destination)
        puts "Skipping #{destination} because it already exists"
      else
        puts "Generating #{destination}"
        FileUtils.cp(source, destination)
      end
    end
  end

  # dtf_setup:config is added to make sure you can copy the *config* without having to recopy
  # the migrations and schema as well.
  desc "config [NAME]", "Copy db configuration file"
  method_options :force => :boolean
  def config(name = "*")
    
    from_dir = "#{Gem.loaded_specs['dtf'].gem_dir}"
    
    Dir["#{from_dir}/examples/db/#{name}"].each do |source|

      # Use File.basename to remove the gem's path info so we can
      # use just the filename to copy relative to the user.
      destination = "#{Dir.pwd}/db/#{File.basename(source)}"

      FileUtils.rm(destination) if options[:force] && File.exist?(destination)
      if File.exist?(destination)
        puts "Skipping #{destination} because it already exists"
      else
        puts "Generating #{destination}"
        FileUtils.cp(source, destination)
      end
    end
  end

end