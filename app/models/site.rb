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

  def self.check_domain
    sites = self.find(:all)
    sites.each do |site|
      unless site.domain_url.blank?
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
  end

  def self.check_ssl
    sites = self.find(:all)

    sites.each do |site|
      unless site.ssl_url.blank?
        begin
          ssl_expired = `echo | openssl s_client -connect #{site.ssl_url}:443 -showcerts | openssl x509 -dates -noout | grep notAfter | cut -c 10-33`
          ary = Date._parse(ssl_expired)
          site.ssl_expired = Time.local(ary[:year], ary[:mon], ary[:day]).strftime('%Y-%m-%d')
        rescue
        else
          site.save
        end
      end
    end
  end

  def self.get_html
    if File.exist?("#{Rails.root}/tmp/intervals/cron.on")
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
    users.each do |user|
      NoticeMailer.sendmail_summary(user, domain_sites, ssl_sites).deliver
    end
  end

end
