# coding: utf-8
class SettingsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def watch_interval
    if params[:interval].nil?
      in_file = File.open(Rails.root + "tmp/intervals/cron.dat", "r")
      @cron_interval = in_file.gets
      in_file.close
    else
      @cron_interval = params[:interval]
      out_file = File.open(Rails.root + "tmp/intervals/cron.dat", "w")
      out_file.write(params[:interval])
      out_file.close
      `whenever --update troch --set environment=development`
    end
  end

end
