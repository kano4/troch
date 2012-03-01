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
      @rank_sites   = [Factory(:site)]
    end

    let(:mail) { NoticeMailer.sendmail_summary(@user, @rank_sites, @domain_sites, @ssl_sites) }

    it "renders the headers" do
      mail.subject.should eq("[Troch]Summary")
    end
  end

  describe "sendmail_health_check" do
    before(:each) do
      @user = Factory(:user)
    end

    let(:mail) { NoticeMailer.sendmail_health_check(@user) }

    it "renders the headers" do
      mail.subject.should eq("[Troch]Health Check Alert")
    end
  end
end
