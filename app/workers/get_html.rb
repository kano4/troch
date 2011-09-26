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
    rescue TimeoutError
      trials += 1
      retry if trials < 3

      site.watch_logs.build(:status => 'timeout', :content => "", :response_time => 0)
      site.save
    rescue Mechanize::ResponseCodeError => ex
      users = User.find(site.users)
      users.each do |user|
        NoticeMailer.sendmail_alert(user, site, ex.response_code).deliver
      end
      site.watch_logs.build(:status => ex.response_code, :content => "", :response_time => 0)
      site.save
    rescue
      users = User.find(site.users)
      users.each do |user|
        NoticeMailer.sendmail_alert(user, site, "invalid url").deliver
      end
      site.watch_logs.build(:status => "invalid url", :content => "", :response_time => 0)
      site.save
    else
      response_time = (end_time - start_time) * 1000

      if last_log = site.watch_logs.find(:last)
        if last_log.content.split(/\n/) == content.split(/\n/)
          site.watch_logs.build(:status => 'ok', :content => content, :response_time => response_time)
        else
          site.watch_logs.build(:status => 'diff', :content => content, :response_time => response_time)
          users = User.find(site.users)
          users.each do |user|
            NoticeMailer.sendmail_alert(user, site, 'diff').deliver
          end
        end
      else
        site.watch_logs.build(:status => 'new', :content => content, :response_time => response_time)
      end
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
