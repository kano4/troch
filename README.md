# Troch [![Build Status](https://secure.travis-ci.org/kano4/troch.png)](http://travis-ci.org/kano4/troch)
Troch is a website monitoring tool.

# Requirements
- Ruby 1.9.2
- SQLite3
- crontab
- OpenSSL
- Redis
- Bundler

# Installation
    git clone https://github.com/kano4/troch.git
    cd troch
    bundle install --without test development
    rake RAILS_ENV=production db:migrate
    rails server -d -e production
    RAILS_ENV=production script/troch_server start

# Function
- Watching Site's Status
- Watching Domain Expired Date
- Watching SSL Expired Date

# Future Work
- MySQL
- Passenger
- Watching SMTP
