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
      begin
        client = Whois.query(site.domain_url)
      rescue
      else
        site.domain_expired = client.expires_on
        site.save
      end
    end
  end

  def self.get_html
    sites = self.all
    sites.each do |site|
      Resque.enqueue(GetHtml, site.id)
    end
  end

end
