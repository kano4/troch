# coding: utf-8
require 'fileutils'
class SettingsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def watch_interval
    if params[:interval].nil?
      begin
        in_file = File.open(Rails.root + "tmp/intervals/cron.dat", "r")
      rescue
        FileUtils.mkdir_p(Rails.root + "tmp/intervals")
        out_file = File.open("tmp/intervals/cron.dat", "w")
        out_file.write(15)
        out_file.close
        @cron_interval = 15
      else
        @cron_interval = in_file.gets
        in_file.close
      end
    else
      @save_message = '保存しました'
      @cron_interval = params[:interval]
      out_file = File.open(Rails.root + "tmp/intervals/cron.dat", "w")
      out_file.write(params[:interval])
      out_file.close
      `whenever --update troch-#{Rails.env} --set environment=#{Rails.env}`
    end
  end

end
