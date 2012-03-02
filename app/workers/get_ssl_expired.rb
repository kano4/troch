# -*- coding: utf-8 -*-
require 'date'

class GetSslExpired
  @queue = "troch_worker_#{ENV['RAILS_ENV']}"

  def self.perform(site_id)
    site = Site.find(site_id)

    if site.ssl_url.blank?
      site.ssl_expired = nil
    else
      begin
        ssl_expired = `echo | openssl s_client -connect #{site.ssl_url}:443 -showcerts | openssl x509 -dates -noout | grep notAfter | cut -c 10-33`
        unless ssl_expired.blank?
          ary = Date._parse(ssl_expired)
          site.ssl_expired = Time.local(ary[:year], ary[:mon], ary[:mday]).strftime('%Y-%m-%d')
        end
      rescue
      end
    end
    site.save
  end

end
