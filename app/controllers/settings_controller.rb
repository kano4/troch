# coding: utf-8
require 'fileutils'
class SettingsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def watch_on_off
    if params[:on_off].nil?
      if File.exist?("#{Rails.root}/tmp/intervals/cron.on")
        @cron_interval = true
      else
        @cron_interval = false
      end
    elsif params[:on_off] == "true"
      if !File.exist?("#{Rails.root}/tmp/intervals/cron.on")
        FileUtils.mkdir_p("#{Rails.root}/tmp/intervals")
        File.open("#{Rails.root}/tmp/intervals/cron.on", "w").close
        @save_message = '起動しました'
      end
      @cron_interval = true
    else
      if File.exist?("#{Rails.root}/tmp/intervals/cron.on")
        File.delete("#{Rails.root}/tmp/intervals/cron.on")
        @save_message = '停止しました'
      end
      @cron_interval = false
    end
  end

end
