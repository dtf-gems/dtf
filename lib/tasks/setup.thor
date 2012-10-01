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
    # Migrations
    from_dir = "#{File.join("#{Gem.loaded_specs['dtf'].gem_dir}", 'db/migrate')}"
    # Add schema.rb and seeds to list of additional files to be pushed
    other_files = ["#{from_dir}/../schema.rb", "#{from_dir}/../seeds.rb"]
    
    other_files.each do |source|
      puts "Generating db/#{File.basename(source)}"
      FileUtils.cp(source, "#{Dir.pwd}/db/#{File.basename(source)}" )
    end

    Dir["#{from_dir}/#{name}"].each do |source|

      # Use File.basename to remove the gem's path info so we can
      # use just the filename to copy relative to the user.
      destination = "#{Dir.pwd}/db/migrate/#{File.basename(source)}"

      FileUtils.rm(destination) if options[:force] && File.exist?(destination) && File.file?(destination)
      if File.directory?(destination)
        puts "Oops, db/migrate/#{File.basename(destination)} is a directory. Skipping!"
      elsif File.exist?(destination)
        puts "Skipping db/migrate/#{File.basename(destination)} because it already exists"
      else
        puts "Generating db/migrate/#{File.basename(destination)}"
        FileUtils.cp(source, destination)
      end
    end
    puts "Don't forget to run 'rake db:setup' next! Run 'rake db:drop:all' first, if your databases already exist."
  end

  # dtf_setup:config is added to make sure you can copy the *config* without having to recopy
  # the migrations and schema as well.
  desc "config [NAME]", "Copy db configuration"
  method_options :force => :boolean
  def config(name = "config.yml")
    
    from_dir = "#{Gem.loaded_specs['dtf'].gem_dir}"
    
    # Use File.basename to remove the gem's path info so we can
    # use just the filename to copy relative to the user.
    destination = "#{Dir.pwd}/db/#{name}"

    FileUtils.rm(destination) if options[:force] && File.exist?(destination) && File.file?(destination)
    if File.directory?(destination)
      puts "Oops, db/#{File.basename(destination)} is a directory. Ignoring!"
    elsif File.exist?(destination)
      puts "Skipping db/#{File.basename(destination)} because it already exists"
    else
      puts "Generating db/#{File.basename(destination)}"
      FileUtils.cp("#{from_dir}/db/#{name}", destination)
    end
    puts "Don't forget to run 'rake db:setup' next! Run 'rake db:drop:all' first, if your databases already exist."
  end

end