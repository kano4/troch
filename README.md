# Troch [![Build Status](https://secure.travis-ci.org/kano4/troch.png)](http://travis-ci.org/kano4/troch)
Troch is a website monitoring tool.

# Requirements
- Ruby 1.9.2
- SQLite3
- crontab
- OpenSSL
- Redis
- Bundler
- libxml2-dev
- libxslt-dev

# Installation
    git clone https://github.com/kano4/troch.git
    cd troch
    bundle install
    rake RAILS_ENV=production db:migrate
    rails server -d -e production
    RAILS_ENV=production script/troch_server start
