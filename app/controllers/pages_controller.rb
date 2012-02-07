# coding: utf-8
class PagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @sites = Site.find(:all)
    @error_num = 0
    @maintenance_num = 0
    @sites.each do |site|
      if !site.watch_logs.last.nil? && site.watch_logs.last.status != "ok" && site.watch_logs.last.status != "new"
        if site.watch_logs.last.status == "maintanance"
          @maintenance_num += 1
        else
          @error_num += 1
        end
      end
    end
    @domain_sites = Site.find(:all, :conditions => ['domain_expired < ?', Date.today + 30], :order => 'domain_expired')
    @ssl_sites = Site.find(:all, :conditions => ['ssl_expired < ?', Date.today + 30], :order => 'ssl_expired')
    @last_log = WatchLog.last

    @cron_status = File.exist?("#{Rails.root}/tmp/intervals/cron.on") ? '監視' : '停止'
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
      if !site.watch_logs.last.nil? && site.watch_logs.last.status != "ok" && site.watch_logs.last.status != "new" && site.watch_logs.last.status != "maintanance"
        @error_sites << site
      end
    end
  end

end
