# encoding: UTF-8
source 'https://rubygems.org'

# Specify your gem's dependencies in dtf.gemspec
platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'jruby-openssl'
  gem 'jdbc-sqlite3'
end

platforms :ruby do
  gem 'sqlite3'
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
end

group :development do
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-developer_tools'
  gem 'pry-syntax-hacks'
  gem 'pry-editline'
  gem 'pry-highlight'
  gem 'pry-buffers'
  gem 'jist'
  gem 'pry-theme'
  gem 'simplecov'
  gem 'database_cleaner'
  gem 'jruby-lint', :platforms => 'jruby'
end

group :test do
  gem 'turnip'
  gem 'rspec'
  gem 'rspec-given'
  gem 'fabrication'
  gem 'database_cleaner'
  gem 'simplecov'
end

gemspec
