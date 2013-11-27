# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dtf/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors           = ["David Deryl Downey"]
  gem.email             = ["me@daviddwdowney.com"]
  gem.description       = %q{DTF is a modular testing framework skeleton. This is the control gem containing the db schema(s) and command-line script.}
  gem.summary           = %q{DTF is a modular testing framework. This is the master gem for the DTF framework.}
  gem.homepage          = "https://github.com/dtf-gems/dtf"
  gem.license           = 'MIT'
  gem.platform          = Gem::Platform::RUBY
  gem.files             = `git ls-files`.split($\)
  gem.executables       = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files        = gem.files.grep(%r{^(test|spec|features)/})
  gem.name              = "dtf"
  gem.require_paths     = ["lib"]
  gem.version           = Dtf::VERSION
  gem.rubyforge_project = "dtf"
  gem.required_ruby_version = ">= 1.9.2"

  gem.add_dependency "thor"
  gem.add_dependency "rake"
  gem.add_dependency "activerecord"
  gem.add_dependency "activemodel"
  gem.add_dependency "activesupport"

  gem.add_dependency "sqlite3" if RUBY_PLATFORM == "ruby"

  gem.add_dependency "jdbc-sqlite3" if RUBY_PLATFORM == "java"
  gem.add_dependency "activerecord-jdbcsqlite3-adapter" if RUBY_PLATFORM == "java"
  gem.add_dependency "jruby-openssl" if RUBY_PLATFORM == "java"

  gem.add_dependency "json"
  gem.add_dependency "json_pure"
  gem.add_dependency "standalone_migrations"
  gem.add_dependency "trollop" # This implements the help system

  gem.add_development_dependency "turnip"
  gem.add_development_dependency "rspec", [">=2.10.0"]
  gem.add_development_dependency "fabrication"
end
