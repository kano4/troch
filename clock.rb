require File.expand_path(File.dirname(__FILE__) + '/config/boot')
require File.expand_path(File.dirname(__FILE__) + '/config/environment')
require 'clockwork'
include Clockwork

ENV['RAILS_ENV'] ||= 'production'
data = YAML.load_file("#{Rails.root}/config/settings.yml")
schedule = data["schedule"]

`cd #{Rails.root} && RAILS_ENV=#{ENV['RAILS_ENV']} script/resque_troch_worker restart >> log/cron.log 2>> log/error.log`

every(schedule["record_time"].minutes, 'record_time')                           { `cd #{Rails.root} && script/rails runner "Resque.enqueue(RecordTime)" -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }

every(schedule["get_html"].minutes,    'site.get_html')                         { `cd #{Rails.root} && script/rails runner Site.get_html            -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.day, 'site.get_domain_expired',  :at => schedule["get_domain_expired"]) { `cd #{Rails.root} && script/rails runner Site.get_domain_expired  -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.day, 'site.get_ssl_expired',     :at => schedule["get_ssl_expired"]   ) { `cd #{Rails.root} && script/rails runner Site.get_ssl_expired     -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.day, 'site.get_page_rank',       :at => schedule["get_page_rank"]     ) { `cd #{Rails.root} && script/rails runner Site.get_page_rank       -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.day, 'site.send_summary',        :at => schedule["send_summary"]      ) { `cd #{Rails.root} && script/rails runner Site.send_summary        -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }

every(1.day, 'watch_log.delete_old_logs',:at => schedule["delete_old_logs"]   ) { `cd #{Rails.root} && script/rails runner WatchLog.delete_old_logs -e #{ENV['RAILS_ENV']} >> log/cron.log 2>> log/error.log` }
every(1.day, 'log_clear',                :at => schedule["log_clear"]         ) { `cd #{Rails.root} && bundle exec rake log:clear --silent >> log/cron.log 2>> log/error.log` }
every(1.day, 'tmp_clear',                :at => schedule["tmp_clear"]         ) { `cd #{Rails.root} && bundle exec rake tmp:clear --silent >> log/cron.log 2>> log/error.log` }
