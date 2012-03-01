# -*- coding: utf-8 -*-
require 'mechanize'

class RecordTime
  @queue = "troch_worker_#{ENV['RAILS_ENV']}"

  def self.perform
    own_time = Time.now
    open("#{Rails.root}/public/record_time", "w") {|f| f.write own_time}
  end
end
