# -*- coding: utf-8 -*-
require 'date'

class GetSslExpired
  @queue = "troch_worker_#{ENV['RAILS_ENV']}"

  def self.perform(site_id)
    site = Site.find(site_id)

    unless site.ssl_url.blank?
      same_ssl_sites = Site.find(:all, :conditions => ['id < ? AND ssl_url = ?', site.id, site.ssl_url])
      if same_ssl_sites.blank?
        begin
          ssl_expired = `echo | openssl s_client -connect #{site.ssl_url}:443 -showcerts | openssl x509 -dates -noout | grep notAfter | cut -c 10-33`
          ary = Date._parse(ssl_expired)
          site.ssl_expired = Time.local(ary[:year], ary[:mon], ary[:mday]).strftime('%Y-%m-%d')
        rescue
        end
      else
        site.ssl_expired = same_ssl_sites.first.ssl_expired
      end
      site.save
    end
  end

end
