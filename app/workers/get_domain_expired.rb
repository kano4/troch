# -*- coding: utf-8 -*-
require 'whois'

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
        site.domain_expired = client.expires_on unless client.expires_on.nil?
      end
    end
    site.save
  end
end
