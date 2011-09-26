# coding: utf-8
class PagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @watchlogs = WatchLog.find(:all, :limit => 10, :order => "updated_at DESC")
    @domain_sites = Site.find(:all, :conditions => ['domain_expired < ?', Date.today + 30], :order => 'domain_expired')
    @ssl_sites = Site.find(:all, :conditions => ['ssl_expired < ?', Date.today + 30], :order => 'ssl_expired')

    begin
      in_file = File.open(Rails.root + "tmp/intervals/cron.dat", "r")
    rescue
      FileUtils.mkdir_p(Rails.root + "tmp/intervals")
      out_file = File.open("#{Rails.root}/tmp/intervals/cron.dat", "w")
      out_file.write(15)
      out_file.close
      `whenever --update troch-#{Rails.env} --set environment=#{Rails.env}`
      @cron_status = '起動中'
    else
      @cron_status = in_file.gets.to_i.eql?(0) ? '停止中' : '起動中'
      in_file.close
    end
  end

end
