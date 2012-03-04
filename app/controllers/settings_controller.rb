# coding: utf-8
require 'fileutils'
class SettingsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def watch_on_off
    if params[:on_off].nil?
      if File.exist?("#{Rails.root}/tmp/cron/cron.on")
        @cron_on = true
      else
        @cron_on = false
      end
    elsif params[:on_off] == "true"
      if !File.exist?("#{Rails.root}/tmp/cron/cron.on")
        FileUtils.mkdir_p("#{Rails.root}/tmp/cron")
        File.open("#{Rails.root}/tmp/cron/cron.on", "w").close
        @save_message = '起動しました'
      end
      @cron_on = true
    else
      if File.exist?("#{Rails.root}/tmp/cron/cron.on")
        File.delete("#{Rails.root}/tmp/cron/cron.on")
        @save_message = '停止しました'
      end
      @cron_on = false
    end
  end

  def info
    @watch_status = File.exist?("#{Rails.root}/tmp/cron/cron.on") ? '監視' : 'メンテナンス'
    data = YAML.load_file("#{Rails.root}/config/settings.yml")
    @schedule = data["schedule"]
    @email    = data["email"]
    if File.exist?("#{Rails.root}/public/record_time")
      file = open("#{Rails.root}/public/record_time")
      record_time = file.first
      @worker_status = (!record_time.nil? && within_1hour?(record_time)) ? '起動中' : '停止中'
    else
      @worker_status = (!record_time.nil? && within_1hour?(record_time)) ? '起動中' : '停止中'
    end

  end

end

def within_1hour?(record_time)
  if Time.parse(record_time) < Time.now - 1 * 60 * 60
    false
  else
    true
  end
end
