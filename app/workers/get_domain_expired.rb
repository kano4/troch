# -*- coding: utf-8 -*-
require 'whois'

class GetDomainExpired
  @queue = "troch_worker_#{ENV['RAILS_ENV']}"

  def self.perform(site_id)
    site = Site.find(site_id)

    unless site.domain_url.blank?
      same_domain_sites = Site.find(:all, :conditions => ['id < ? AND domain_url = ?', site.id, site.domain_url])
      if same_domain_sites.blank?
        trials = 0
        begin
          client = Whois.query(site.domain_url)
        rescue
          trials += 1
          retry if trials < 3
        else
          site.domain_expired = client.expires_on
        end
      else
        site.domain_expired = same_domain_sites.first.domain_expired
      end
      site.save
    end
  end
end
