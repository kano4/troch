# coding: utf-8
class NoticeMailer < ActionMailer::Base
  @@data = YAML.load_file("#{Rails.root}/config/settings.yml")
  default :from => @@data["email"]["from"]

  def sendmail_alert(user, site, status, diff_html = '')
    @user_email = user.email.force_encoding("UTF-8")
    @site_name = site.name.force_encoding("UTF-8")
    @site_url = site.url.force_encoding("UTF-8")
    @status = status.force_encoding("UTF-8")
    @diff_html = diff_html.force_encoding("UTF-8")

    @date = Time.now.strftime('%Y/%m/%d %H:%M:%S').force_encoding("UTF-8")

    mail to: user.email,
         subject: "[Troch]#{@status}:#{@site_name}"
  end

  def sendmail_summary(user, rank_sites, domain_sites, ssl_sites)
    @cron_status = File.exist?("#{Rails.root}/tmp/cron/cron.on") ? '監視' : '停止'
    @rank_sites   = rank_sites
    @domain_sites = domain_sites
    @ssl_sites    = ssl_sites
    mail to: user.email,
         subject: '[Troch]Summary'
  end

  def sendmail_health_check(user)
    @email = user.email
    mail to: @email,
         subject: '[Troch]Health Check Alert'
  end
end
