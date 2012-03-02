source 'http://rubygems.org'

gem 'rails', '~> 3.2.0'

case ENV['DB']
when "postgres"; gem "pg"
when "sqlite";   gem "sqlite3"
else
  gem "mysql2"
end

gem 'passenger'
gem 'unicorn'
gem 'clockwork'

gem 'therubyracer'
gem 'hpricot'
gem 'ruby_parser'
gem 'devise'
gem 'bcrypt-ruby'
gem 'diff-lcs'
gem 'mechanize'
gem 'whois'
gem 'resque'
gem 'daemon-spawn', :require => 'daemon_spawn'
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

gem 'jquery-rails'
gem 'pjax-rails'
gem 'sprockets'
gem 'haml-rails'

group :assets do
  gem 'sass-rails'
  gem 'coffee-script'
  gem 'uglifier'
end

group :development, :test do
  gem 'thin'
  gem 'prefetch-rspec'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'forgery'
  gem 'rails3-generators'
end
