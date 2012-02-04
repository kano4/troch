# coding: utf-8
require 'mechanize'
require 'base64'
require 'diff/lcs'

class GetHtml
  @queue = :default

  def self.perform(site_id)
    site = Site.find(site_id)
    unless site.url.blank?
      trials = 0
      begin
        start_time = Time.now

        if site.watch_method == 'html_body'
          content = get_page_body(site.url)
        elsif site.watch_method == 'html_title'
          content = get_page_title(site.url)
        elsif site.watch_method == 'html_keyword' && !site.keyword.blank?
          content = get_page_keyword(site.url, site.keyword)
        end

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
        encoded_content = Base64.encode64(content)

        if last_log = site.watch_logs.find(:last, :conditions => {:status => ['ok', 'diff', 'new']})
          if last_log.content == encoded_content || content == site.keyword
            last_log.content = ''
            last_log.save
            site.watch_logs.build(:status => 'ok',   :content => encoded_content, :response_time => response_time)
          elsif site.watch_method == 'html_keyword' && content != site.keyword
            site.watch_logs.build(:status => 'keyword error', :content => content, :response_time => response_time)
          else
            site.watch_logs.build(:status => 'diff', :content => encoded_content, :response_time => response_time)
            get_content  = Base64.decode64(last_log.content)
            last_content = Base64.decode64(encoded_content)
            diffs = Diff::LCS.sdiff(get_content.split, last_content.split)
            diff_html = ""
            diffs.each do |d|
              if d.old_element != d.new_element
                diff_html << "-#{d.old_element}\n" if d.old_element
                diff_html << "+#{d.new_element}\n" if d.new_element
              end
            end

            users = User.find(site.users)
            users.each do |user|
              NoticeMailer.sendmail_alert(user, site, 'diff', diff_html).deliver
            end
          end
        else
          site.watch_logs.build(:status => 'new', :content => encoded_content, :response_time => response_time)
        end
        site.save
      end
    end
  end
end

def get_page_body(url)
  agent = Mechanize.new
  page = agent.get(url)
  page.body
end

def get_page_title(url)
  agent = Mechanize.new
  page = agent.get(url)
  page.title || 'no title'
end

def get_page_keyword(url, keyword)
  agent = Mechanize.new
  page = agent.get(url)
  page.body.to_s.include?(keyword) ? keyword : "There is no keyword '#{keyword}'. #{Time.now}"
end
