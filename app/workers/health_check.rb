# -*- coding: utf-8 -*-
require 'mechanize'

class HealthCheck
  @queue = "troch_worker_#{ENV['RAILS_ENV']}"

  @target_url = YAML.load_file("#{Rails.root}/config/settings.yml")["health_check"]["target_url"]

  def self.perform
    unless @target_url.blank?
      agent = Mechanize.new
      trials = 0
      begin
        target_time = agent.get("#{@target_url}/record_time").body
      rescue
        trials += 1
        retry if trials < 3
      end

      if !target_time.nil? && within_3hours?(target_time)
        puts "Troch (#{@target_url}) is running normally. #{Time.now}"
      else
        puts "Troch (#{@target_url}) has broken down! #{Time.now}"
        users = User.find(:all, :conditions => {:summary => true})
        users.each do |user|
          NoticeMailer.sendmail_health_check(user, @target_url).deliver
        end
      end
    end

    own_time = Time.now
    open("#{Rails.root}/public/record_time", "w") {|f| f.write own_time}
  end
end

def within_3hours?(target_time)
  if Time.parse(target_time) < Time.now - 3 * 60 * 60
    false
  else
    true
  end
end
