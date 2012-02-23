# coding: utf-8
require 'mechanize'
require 'base64'
require 'diff/lcs'
require 'nkf'

class GetHtml
  @queue = "troch_worker_#{ENV['RAILS_ENV']}"

  def self.perform(site_id)
    site = Site.find(site_id)

    if site.url.blank? || site.url == "http://"
      site.watch_logs.build(:status => "maintenance", :content => "", :response_time => 0)
    else
      trials = 0
      begin
        agent = Mechanize.new
        start_time = Time.now
        page = agent.get(site.url)
        end_time = Time.now
        content = get_html_content(page, site)
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
            if response_time > 15 * 1000
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

def sendmail_alert(site, response_code, diff_html = '')
  users = []
  site.users.each do |user|
    users << User.find(user)
  end
  users.each do |user|
    NoticeMailer.sendmail_alert(user, site, response_code, diff_html).deliver
  end
end

def get_diff(old_content, new_content)
  old_content  = NKF.nkf('-wm0', Base64.decode64(old_content).to_s.force_encoding("UTF-8")).split
  new_content  = NKF.nkf('-wm0', Base64.decode64(new_content).to_s.force_encoding("UTF-8")).split
  diffs = Diff::LCS.sdiff(old_content, new_content)
  diff_html = ""
  diffs.each do |d|
    if d.old_element != d.new_element
      diff_html << "- #{d.old_element}\n" if d.old_element
      diff_html << "+ #{d.new_element}\n" if d.new_element
    end
  end
  diff_html
end

def get_html_content(page, site)
  if site.watch_method == 'html_body'
    get_page_body(page, site.cut_tag)
  elsif site.watch_method == 'html_title'
    get_page_title(page)
  elsif site.watch_method == 'html_keyword' && !site.keyword.blank?
    get_page_keyword(page, site.keyword)
  end
end

def strip_whiteline(str_with_whiteline)
  str_without_whiteline = ''
  str_with_whiteline.split(/((?:\r?\n)+)/).each do |str|
    str_without_whiteline += "#{str}\n" unless str.blank?
  end
  str_without_whiteline
end

def get_page_body(page, cut_tag = nil)
  body = NKF.nkf('-wm0', page.parser).to_s.force_encoding("UTF-8") || 'no body'

  if !cut_tag.blank?
    patterns_with_linebreak = page.parser.search(cut_tag)
    patterns_with_linebreak.each do |pattern_with_linebreak|
      patterns = NKF.nkf('-wm0', pattern_with_linebreak).to_s.force_encoding("UTF-8").split(/((?:\r?\n)+)/)
      patterns.each do |pattern|
        body = body.sub(NKF.nkf('-wm0', pattern).to_s.force_encoding("UTF-8"), '')
      end
    end
  end

  strip_whiteline(body)
end

def get_page_title(page)
  page.title.to_s.force_encoding("UTF-8") || 'no title'
end

def get_page_keyword(page, keyword='')
  page.body.to_s.force_encoding("UTF-8").include?(keyword) ? keyword : "There is no keyword '#{keyword}'. #{Time.now}"
end
