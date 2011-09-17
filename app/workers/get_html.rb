require 'mechanize'
class GetHtml
  @queue = :default

  def self.perform(site_id)
    site = Site.find(site_id)
    trials = 0
    begin
      start_time = Time.now
      content = get_page_body(site.url)
      end_time = Time.now
    rescue
      trials += 1
      retry if trials < 3
      site.watch_logs.build(:status => 'error', :content => "", :response_time => 0)
      site.save
    else
      response_time = (end_time - start_time) * 1000
      site.watch_logs.build(:status => 'ok', :content => content, :response_time => response_time)
      site.save
    end
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
