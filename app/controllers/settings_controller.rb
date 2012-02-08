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

end
