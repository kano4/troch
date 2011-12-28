# coding: utf-8
class NoticeMailer < ActionMailer::Base
  @@data = YAML.load_file("#{Rails.root}/config/email.yml")
  default :from => @@data["default"]["from"]

  def sendmail_alert(user, site, status, diff_html = '')
    @user = user
    @site = site
    @status = status
    @diff_html = diff_html
    @date = Time.now.strftime('%Y/%m/%d %H:%M:%S')

    mail to: user.email,
         subject: "[Troch]#{@status}:#{@site.name}"
  end

  def sendmail_summary(user, domain_sites, ssl_sites)
    @user = user
    @domain_sites = domain_sites
    @ssl_sites    = ssl_sites
    mail to: user.email,
         subject: '[Troch]Summary'
  end
end
