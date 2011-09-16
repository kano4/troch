# coding: utf-8
class Site < ActiveRecord::Base
  has_many :watch_logs
  has_many :users_sites
  has_many :users, :through => :users_sites
  validates_presence_of :name, :url

protected
  require 'whois'
  def self.check_domain
    sites = self.find(:all, :conditions => ['domain_url NOT ?', nil])
    sites.each do |site|
      trials = 0
      begin
        client = Whois.query(site.domain_url)
      rescue
        trials += 1
        retry if trials < 3
      else
        site.domain_expired = client.expires_on
        site.save
      end
    end
  end

  def self.get_html
    sites = self.all
    cron_time = Time.now.strftime("%M").to_i
    sites.each do |site|
      if cron_time % site.watch_interval == 0
        Resque.enqueue(GetHtml, site.id)
      end
    end
  end

  def self.send_alert
    users = User.find(:all)
    users.each do |user|
      @mail = NoticeMailer.sendmail_alert(user).deliver
    end
  end

  def self.send_summary
    users = User.find(:all)
    domain_sites = Site.find(:all, :conditions => ['domain_expired < ?', Date.today + 30], :order => 'domain_expired')
    ssl_sites    = Site.find(:all, :conditions => ['ssl_expired < ?', Date.today + 30], :order => 'ssl_expired')
    users.each do |user|
      NoticeMailer.sendmail_summary(user, domain_sites, ssl_sites).deliver
    end
  end

end
