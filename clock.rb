require File.expand_path(File.dirname(__FILE__) + '/config/boot')
require File.expand_path(File.dirname(__FILE__) + '/config/environment')
require 'clockwork'
include Clockwork

ENV['RAILS_ENV'] ||= 'production'

#every(10.seconds, 'site.get_html') { `cd #{Rails.root} && script/rails runner Site.get_html -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.hour, 'site.get_html', :at => ['**:00', '**:15', '**:30', '**:45']) { `cd #{Rails.root} && script/rails runner Site.get_html -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.day, 'site.check_domain', :at => '08:00') { `cd #{Rails.root} && script/rails runner Site.check_domain -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.day, 'site.check_ssl',    :at => '08:00') { `cd #{Rails.root} && script/rails runner Site.check_ssl    -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.day, 'site.send_summary', :at => '10:00') { `cd #{Rails.root} && script/rails runner Site.send_summary -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }

every(1.day, 'log_clear', :at => '12:00') { `cd #{Rails.root} && bundle exec rake log:clear --silent >> log/cron.log 2>> log/error.log` }
every(1.day, 'restart_worker', :at => '12:00') { `cd #{Rails.root} && RAILS_ENV=#{ENV['RAILS_ENV']} script/troch_server restart >> log/cron.log 2>> log/error.log` }
