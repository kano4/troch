# coding: utf-8
require 'mechanize'
require 'base64'
require 'diff/lcs'
require 'nkf'

class GetHtml
  @queue = :troch_worker

  def self.perform(site_id)
    site = Site.find(site_id)

    if site.url.blank? || site.url == "http://"
      site.watch_logs.build(:status => "maintenance", :content => "", :response_time => 0)
    else
      trials = 0
      begin
        start_time = Time.now
        content = get_html_content(site)
        end_time = Time.now
      rescue TimeoutError
        trials += 1
        retry if trials < 3

        site.watch_logs.build(:status => 'timeout', :content => "", :response_time => 0)
      rescue Mechanize::ResponseCodeError => ex
        sendmail_alert(site, ex.response_code)
        site.watch_logs.build(:status => ex.response_code, :content => "", :response_time => 0)
      rescue
        sendmail_alert(site, 'invalid url')
        site.watch_logs.build(:status => "invalid url", :content => "", :response_time => 0)
      else
        response_time = (end_time - start_time) * 1000
        encoded_content = Base64.encode64(content)

        if last_log = site.watch_logs.find(:last, :conditions => {:status => ['ok', 'diff', 'new']})
          if last_log.content == encoded_content || content == site.keyword
            last_log.content = ''
            last_log.save
            if response_time > 10 * 1000
              site.watch_logs.build(:status => 'delay', :content => encoded_content, :response_time => response_time)
            else
              site.watch_logs.build(:status => 'ok',    :content => encoded_content, :response_time => response_time)
            end
          elsif site.watch_method == 'html_keyword' && content != site.keyword
            site.watch_logs.build(:status => 'keyword error', :content => content, :response_time => response_time)
          else
            site.watch_logs.build(:status => 'diff', :content => encoded_content, :response_time => response_time)

            diff_html = get_diff(last_log.content, encoded_content)

            sendmail_alert(site, 'diff', diff_html)
          end
        else
          site.watch_logs.build(:status => 'new', :content => encoded_content, :response_time => response_time)
        end
      end
    end
    site.save
  end
end

def get_html_content(site)
  if site.watch_method == 'html_body'
    get_page_body(site.url)
  elsif site.watch_method == 'html_title'
    get_page_title(site.url)
  elsif site.watch_method == 'html_keyword' && !site.keyword.blank?
    get_page_keyword(site.url, site.keyword)
  end
end

def sendmail_alert(site, response_code, diff_html = '')
  users = User.find(site.users)
  users.each do |user|
    NoticeMailer.sendmail_alert(user, site, response_code, diff_html).deliver
  end
end

def get_diff(old_content, new_content)
  old_content  = Base64.decode64(old_content).split
  new_content = Base64.decode64(new_content).split
  diffs = Diff::LCS.sdiff(old_content, new_content)
  diff_html = ""
  diffs.each do |d|
    if d.old_element != d.new_element
      diff_html << "-#{d.old_element}\n" if d.old_element
      diff_html << "+#{d.new_element}\n" if d.new_element
    end
  end
  diff_html
end

def get_page_body(url)
  agent = Mechanize.new
  page = agent.get(url)
  NKF.nkf('-wm0', page.parser.to_s.force_encoding("UTF-8")) || 'no body'
end

def get_page_title(url)
  agent = Mechanize.new
  page = agent.get(url)
  page.title.to_s.force_encoding("UTF-8") || 'no title'
end

def get_page_keyword(url, keyword)
  agent = Mechanize.new
  page = agent.get(url)
  page.body.to_s.force_encoding("UTF-8").include?(keyword) ? keyword : "There is no keyword '#{keyword}'. #{Time.now}"
end
