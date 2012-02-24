# coding: utf-8
class Site < ActiveRecord::Base
  belongs_to :group
  has_many :watch_logs
  has_many :users_sites
  has_many :users, :through => :users_sites
  validates_presence_of :name

protected
  require 'whois'
  require 'date/format'

  def self.get_domain_expired
    sites = self.all
    sites.each do |site|
      Resque.enqueue(GetDomainExpired, site.id)
    end
  end

  def self.get_ssl_expired
    sites = self.all
    sites.each do |site|
      Resque.enqueue(GetSslExpired, site.id)
    end
  end

  def self.get_page_rank
    sites = self.all
    sites.each do |site|
      Resque.enqueue(GetPageRank, site.id)
    end
  end

  def self.get_html
    if File.exist?("#{Rails.root}/tmp/cron/cron.on")
      sites = self.all
      sites.each do |site|
        Resque.enqueue(GetHtml, site.id)
      end
    end
  end

  def self.send_summary
    users = User.find(:all, :conditions => {:summary => true})
    domain_sites = Site.find(:all, :conditions => ['domain_expired < ?', Date.today + 30], :order => 'domain_expired')
    ssl_sites    = Site.find(:all, :conditions => ['ssl_expired < ?', Date.today + 30], :order => 'ssl_expired')
    rank_sites   = Site.find(:all, :conditions => ['page_rank <> page_rank_old'])
    users.each do |user|
      NoticeMailer.sendmail_summary(user, rank_sites, domain_sites, ssl_sites).deliver
    end
  end

end
