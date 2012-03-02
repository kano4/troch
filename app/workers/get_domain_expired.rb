# -*- coding: utf-8 -*-
require 'whois'
require 'date'

class GetDomainExpired
  @queue = "troch_worker_#{ENV['RAILS_ENV']}"

  def self.perform(site_id)
    site = Site.find(site_id)

    if site.domain_url.blank?
      site.domain_expired = nil
    else
      same_domain_sites = Site.find(:all, :conditions => ['id < ? AND domain_url = ?', site.id, site.domain_url])
      if same_domain_sites.blank?
        begin
          client = Whois.query(site.domain_url)
        rescue
        else
          if client.expires_on.nil?
            reg = Regexp.new('(Connected \((.*)\))')
            state = reg.match(client.to_s)
            expired_date = Date.strptime(state[2], "%Y/%m/%d") unless state.blank?
            site.domain_expired = expired_date unless expired_date.blank?
          else
            site.domain_expired = client.expires_on unless client.expires_on.nil?
          end
        end
      else
        site.domain_expired = same_domain_sites.first.domain_expired
      end
    end
    site.save
  end
end
