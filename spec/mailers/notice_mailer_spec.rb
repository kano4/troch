require "spec_helper"

describe NoticeMailer do
  describe "sendmail_alert" do
    before(:each) do
      @user = Factory(:user)
      @site = Factory(:site)
      @status = 'status'
    end

    let(:mail) { NoticeMailer.sendmail_alert(@user, @site, @status) }

    it "renders the headers" do
      mail.subject.should eq("[Troch]#{@status}:#{@site.name}")
    end
  end

  describe "sendmail_summary" do
    before(:each) do
      @user = Factory(:user)
      @domain_sites = [Factory(:site)]
      @ssl_sites    = [Factory(:site)]
    end

    let(:mail) { NoticeMailer.sendmail_summary(@user, @domain_sites, @ssl_sites) }

    it "renders the headers" do
      mail.subject.should eq("[Troch]Summary")
    end
  end
end
