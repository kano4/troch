require 'mechanize'
class GetHtml
  @queue = :default

  def self.perform(site_id)
    site = Site.find(site_id)
    start_time = Time.now
    content = get_page_title(site.url)
    end_time = Time.now
    response_time = (end_time - start_time) * 1000
    site.watch_logs.build(:status => 'ok', :content => content, :response_time => response_time)
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
