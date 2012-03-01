# coding: utf-8
require 'time'
class PagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @sites = Site.find(:all)
    @error_sites = []
    @error_num = 0
    @maintenance_num = 0
    @sites.each do |site|
      if !site.watch_logs.last.nil? && site.watch_logs.last.status != "ok" && site.watch_logs.last.status != "new"
        if site.watch_logs.last.status == "maintenance"
          @maintenance_num += 1
        else
          @error_num += 1
          @error_sites << site
        end
      end
    end
    @normal_num = @sites.size - @maintenance_num - @error_num
    @domain_sites = Site.find(:all, :conditions => ['domain_expired < ?', Date.today + 30], :order => 'domain_expired')
    @ssl_sites = Site.find(:all, :conditions => ['ssl_expired < ?', Date.today + 30], :order => 'ssl_expired')
    @last_log = WatchLog.last

    @cron_status = File.exist?("#{Rails.root}/tmp/cron/cron.on") ? '監視' : 'メンテナンス'

    if File.exist?("#{Rails.root}/public/record_time")
      file = open("#{Rails.root}/public/record_time")
      record_time = file.first
      unless !record_time.nil? && within_1hour?(record_time)
        flash[:error] = "バックグラウンドジョブが停止中です。管理者に連絡してください。"
      end
    end
  end

  def edit
    @user = current_user
    @groups = Group.find(:all)
    @nogroup_sites = Site.find(:all)
    @groups.each do |group|
      @nogroup_sites -= group.sites
    end
  end

  def update
    params[:user][:site_ids] ||= []
    @sites = Site.find(:all) if @sites.nil?
    @user = current_user

    if @user.update_attributes(params[:user])
      redirect_to edit_path, notice: "ユーザ情報を更新しました。"
    else
      render action: "edit"
    end
  end

  def log
    redirect_to action: "log" if request.headers["X-PJAX"]

    @watch_logs = WatchLog.find(:all, :conditions => ['status <> "ok"'], :limit => 200, :order => "updated_at DESC")
  end

  def alert
    redirect_to action: "alert" if request.headers["X-PJAX"]

    @sites = Site.find(:all)
    @error_sites = []
    @sites.each do |site|
      if !site.watch_logs.last.nil? && site.watch_logs.last.status != "ok" && site.watch_logs.last.status != "new" && site.watch_logs.last.status != "maintenance"
        @error_sites << site
      end
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
