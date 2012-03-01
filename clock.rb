require File.expand_path(File.dirname(__FILE__) + '/config/boot')
require File.expand_path(File.dirname(__FILE__) + '/config/environment')
require 'clockwork'
include Clockwork

ENV['RAILS_ENV'] ||= 'production'

`cd #{Rails.root} && RAILS_ENV=#{ENV['RAILS_ENV']} script/troch_worker restart >> log/cron.log 2>> log/error.log`

every(15.minutes, 'site.get_html') { `cd #{Rails.root} && script/rails runner Site.get_html -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.day, 'site.get_domain_expired',  :at => '06:00') { `cd #{Rails.root} && script/rails runner Site.get_domain_expired  -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.day, 'site.get_ssl_expired',     :at => '07:00') { `cd #{Rails.root} && script/rails runner Site.get_ssl_expired     -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.day, 'site.get_page_rank', :at => '08:00') { `cd #{Rails.root} && script/rails runner Site.get_page_rank -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.day, 'site.send_summary',  :at => '10:00') { `cd #{Rails.root} && script/rails runner Site.send_summary  -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }

every(1.day, 'watch_log.delete_old_logs', :at => '12:00') { `cd #{Rails.root} && script/rails runner WatchLog.delete_old_logs -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.day, 'log_clear', :at => '12:00') { `cd #{Rails.root} && bundle exec rake log:clear --silent >> log/cron.log 2>> log/error.log` }
every(1.day, 'tmp_clear', :at => '12:00') { `cd #{Rails.root} && bundle exec rake tmp:clear --silent >> log/cron.log 2>> log/error.log` }

every(10.minutes, 'record_time') { `cd #{Rails.root} && RAILS_ENV=#{ENV['RAILS_ENV']} script/rails runner "Resque.enqueue(RecordTime)" >> log/cron.log 2>> log/error.log` }
