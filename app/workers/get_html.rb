require 'mechanize'
class GetHtml
  @queue = :default

  def self.perform(site_id)
    site = Site.find(site_id)
    site.watch_logs.build(:status => 'ok', :content => get_page_title(site.url))
    site.save
  end
end

def get_page_title(url)
  agent = Mechanize.new
  page = agent.get(url)
  page.title
end

def get_page_body(url)
  agent = Mechanize.new
  page = agent.get(url)
  page.body
end
