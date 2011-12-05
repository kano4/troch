# Troch [![Build Status](https://secure.travis-ci.org/kano4/troch.png)](http://travis-ci.org/kano4/troch)
Troch is a website monitoring tool.

# Requirements
- Ruby 1.9.2 or 1.9.3
- MySQL
- crontab
- OpenSSL
- Redis
- Bundler

# Installation

1. Download

        $ git clone https://github.com/kano4/troch.git troch

2. Install gems

        $ cd troch
        $ bundle install

3. Set up database

        $ cp config/database.example.yml config/database.yml

    Edit config/database.yml . For example,

        production:
          adapter: mysql2
          database: troch
          username: root
          password:
          encoding: utf8
          host: localhost
          socket: /var/run/mysqld/mysqld.sock

    Create database

        $ rake db:create RAILS_ENV="production"
        $ rake db:migrate RAILS_ENV="production"

4. Set up crontab

        $ whenever --update troch --set environment="production"

5. Start web server

        $ rails server -d -e production

6. Start redis server

        $ script/troch_server start RAILS_ENV="production"


# Function
- Watching Site Status
  - body
  - title
  - keyword
- Watching Domain Expired Date
- Watching SSL Expired Date

# Future Work
- Passenger
- Watching SMTP
