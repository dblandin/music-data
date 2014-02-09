source 'https://rubygems.org'

gem 'rails',        '~> 4.0.2'
gem 'pg',           '~> 0.17.0'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails', '~> 3.0.4'
gem 'jbuilder',     '~> 1.2'
gem 'unicorn',      '~> 4.7.0'
gem 'dotenv-rails', '~> 0.9.0'
gem 'sinatra',      '~> 1.3.3', require: false
gem 'sidekiq',      '~> 2.17.3'
gem 'oj',           '~> 2.4.3'
gem 'hiredis',      '~> 0.4.5'
gem 'redis',        '~> 3.0.2'


group :production do
  gem 'clockwork', '~> 0.7'
  gem 'daemons',   '~> 1.1'
end

group :development do
  gem 'capistrano', '~> 3.0.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
end

group :test do
  gem 'pry',         '~> 0.9.8',  require: false
  gem 'rspec-rails', '~> 2.14.0', require: false
  gem 'vcr',         '~> 2.4.0',  require: false
  gem 'webmock',     '~> 1.9.0',  require: false
end

gem 'debugger', '~> 1.6.3', group: [:development, :test]
