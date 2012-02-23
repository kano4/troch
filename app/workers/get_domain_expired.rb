# -*- coding: utf-8 -*-
require 'whois'

class GetDomainExpired
  @queue = "troch_worker_#{ENV['RAILS_ENV']}"

  def self.perform(site_id)
    site = Site.find(site_id)

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
