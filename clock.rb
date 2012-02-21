require File.expand_path(File.dirname(__FILE__) + '/config/boot')
require File.expand_path(File.dirname(__FILE__) + '/config/environment')
require 'clockwork'
include Clockwork

ENV['RAILS_ENV'] ||= 'development'

every(1.hour, 'site.get_html', :at => ['**:00', '**:15', '**:30', '**:45']) { Site.get_html }
every(1.day, 'site.check_domain', :at => '08:00') { Site.check_domain }
every(1.day, 'site.check_ssl',    :at => '08:00') { Site.check_ssl    }
every(1.day, 'site.send_summary', :at => '10:00') { Site.send_summary }

every(1.day, 'log_clear', :at => '12:00') { `cd #{Rails.root} && bundle exec rake log:clear --silent >> log/cron.log 2>> log/error.log` }
every(1.day, 'restart_worker', :at => '12:00') { `cd #{Rails.root} && RAILS_ENV=#{ENV['RAILS_ENV']} script/troch_server restart >> log/cron.log 2>> log/error.log` }
