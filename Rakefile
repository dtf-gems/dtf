#!/usr/bin/env rake
# encoding: UTF-8

require "bundler/gem_tasks"

begin
  require 'tasks/standalone_migrations'
rescue LoadError => e
  puts "gem install standalone_migrations to get db:migrate:* tasks! (Error: #{e})"
end

namespace :cover_me do

  desc "Generates and opens code coverage report."
  task :report do
    require 'cover_me'
    CoverMe.complete!
  end

end

task :test do
  Rake::Task['cover_me:report'].invoke
end

task :spec do
  Rake::Task['cover_me:report'].invoke
end

namespace :dtf do

  desc "Install DTF thor tasks"
  task :install do
    require 'dtf'
    puts "Installing DTF tasks"
    FileUtils.cp(Dir.glob("#{File.join("#{Gem.loaded_specs['dtf'].gem_dir}", 'lib/tasks/*')}"), 'lib/tasks/')
  end
end

