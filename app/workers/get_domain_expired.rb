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
      trials = 0
      begin
        client = Whois.query(site.domain_url)
      rescue
        trials += 1
        retry if trials < 3
      else
        if client.expires_on.nil?
          reg = Regexp.new('(Connected \((.*)\))')
          expired_date = Date.strptime(reg.match(client.to_s)[2], "%Y/%m/%d")
          site.domain_expired = expired_date unless expired_date.blank?
        else
          site.domain_expired = client.expires_on unless client.expires_on.nil?
        end
      end
    end
    site.save
  end
end
