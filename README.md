# Troch [![Build Status](https://secure.travis-ci.org/kano4/troch.png)](http://travis-ci.org/kano4/troch)
Troch is a website monitoring tool.
Troch is open source.

# Features
- Watch Site
  - check difference between current html body and old html body
  - check difference between current title and old title
  - determine whether keyword is present
- Get Domain Expired Date
- Get SSL Expired Date
- Get Google PageRank

# Requirements
- Ruby 1.9.2 or 1.9.3
- MySQL, PostgreSQL or SQLite3
- OpenSSL
- Redis

# Installation
1. Download

        $ git clone https://github.com/kano4/troch.git troch

2. Install gems

        $ cd troch
        $ DB=mysql bundle install --without development test

3. Set up smtp

        $ cp config/settings.example.yml config/settings.yml

    Edit config/settings.yml . For example,

        default:
          from: 'troch@example.com'

        settings:
          address: 'smtp.example.com'
          port: 25
          domain: 'example.com'

4. Set up database

        $ cp config/database.mysql.yml config/database.yml

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

    Copy startup script.

        (Red Hat)
        # cp ext/troch-worker.redhat /etc/init.d/troch-worker

        (Ubuntu)
        # cp ext/troch-worker.ubuntu /etc/init.d/troch-worker

    Edit TROCH_ROOT in /etc/init.d/troch-worker . For example,

        TROCH_ROOT="/srv/troch"

    Add troch-worker into startup script and start troch-worker.

        (Red Hat)
        # chkconfig --add troch-worker
        # /etc/init.d/troch-worker start

        (Ubuntu)
        # sysv-rc-conf troch-worker on
        # /etc/init.d/troch-worker start
