# coding: utf-8
class NoticeMailer < ActionMailer::Base
  default from: FROM_ADDR

  def sendmail_alert(user)
    @user = user

    mail to: user.email,
         subject: '[Troch]Alert'
  end

  def sendmail_summary(user, domain_sites, ssl_sites)
    @user = user
    @domain_sites = domain_sites
    @ssl_sites    = ssl_sites
    mail to: user.email,
         subject: '[Troch]Summary'
  end
end
