# -*- coding: utf-8 -*-
require 'date'

class CheckSsl
  @queue = :troch_worker

  def self.perform(site_id)
    site = Site.find(site_id)

    unless site.ssl_url.blank?
      begin
        ssl_expired = `echo | openssl s_client -connect #{site.ssl_url}:443 -showcerts | openssl x509 -dates -noout | grep notAfter | cut -c 10-33`
        ary = Date._parse(ssl_expired)
        site.ssl_expired = Time.local(ary[:year], ary[:mon], ary[:mday]).strftime('%Y-%m-%d')
      rescue
      else
        site.save
      end
    end
  end

end
