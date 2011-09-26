# coding: utf-8
class NoticeMailer < ActionMailer::Base
  default from: FROM_ADDR

  def sendmail_alert(user, site, status)
    @user = user
    @site = site
    @status = status
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
