# Troch [![Build Status](https://secure.travis-ci.org/kano4/troch.png)](http://travis-ci.org/kano4/troch)
Troch is a website monitoring tool.
Troch is open source.

# Features
- Watching Site Status
  - body
  - title
  - keyword
- Watching Domain Expired Date
- Watching SSL Expired Date

# Requirements
- Ruby 1.9.2 or 1.9.3
- MySQL
- OpenSSL
- Redis

# Installation

1. Download

        $ git clone https://github.com/kano4/troch.git troch

2. Install gems

        $ cd troch
        $ bundle install

3. Set up smtp

        $ cp config/email.example.yml config/email.yml

    Edit config/email.yml . For example,

        default:
          from: 'troch@example.jp'

        settings:
          address: 'smtp.example.jp'
          port: 25
          domain: 'example.jp'

4. Set up database

        $ cp config/database.example.yml config/database.yml

    Edit config/database.yml . For example,

        production:
          adapter: mysql2
          database: troch
          username: troch
          password: troch
          encoding: utf8
          host: localhost
          socket: /var/run/mysqld/mysqld.sock

    Create database

        $ RAILS_ENV="production" bundle exec rake db:setup

5. Start web server

        $ bundle exec rails server -d -e production

    View at: http://localhost:3000/
    Or install passenger and edit apache or nginx config.

6. Start worker

        $ nohup bundle exec clockwork clock.rb > log/clock_out.log 2> log/clock_error.log &

    Or edit /etc/rc.d/rc.local as below.

        cd /path/to/troch && RAILS_ENV=production bundle exec clockwork clock.rb > log/clock_out.log 2> log/clock_error.log &
