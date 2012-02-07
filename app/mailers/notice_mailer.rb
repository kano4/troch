# coding: utf-8
class NoticeMailer < ActionMailer::Base
  @@data = YAML.load_file("#{Rails.root}/config/email.yml")
  default :from => @@data["default"]["from"]

  def sendmail_alert(user, site, status, diff_html = '')
    @user_email = user.email.force_encoding("UTF-8")
    @site_name = site.name.force_encoding("UTF-8")
    @site_url = site.url.force_encoding("UTF-8")
    @status = status.force_encoding("UTF-8")
    @diff_html = diff_html.encode("UTF-16BE", :invalid => :replace, :undef => :replace, :replace => '?').encode("UTF-8")
    @date = Time.now.strftime('%Y/%m/%d %H:%M:%S').force_encoding("UTF-8")

    mail to: user.email,
         subject: "[Troch]#{@status}:#{@site.name}"
  end

  def sendmail_summary(user, domain_sites, ssl_sites)
    @user_email = user.email.force_encoding("UTF-8")
    @domain_sites = domain_sites
    @ssl_sites    = ssl_sites
    mail to: user.email,
         subject: '[Troch]Summary'
  end
end
