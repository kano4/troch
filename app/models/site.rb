# coding: utf-8
class Site < ActiveRecord::Base
  has_many :users_sites
  has_many :users, :through => :users_sites
  validates_presence_of :name, :url

protected
  require 'mechanize'
  def get_html
    agent = Mechanize.new
    begin
      agent.get(self.url)
    rescue
      return "URLが不正"
    else
      return agent.page.parser
    end
  end
end
