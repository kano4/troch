require "spec_helper"

describe NoticeMailer do
  describe "sendmail_alert" do
    before(:each) do
      @user = Factory(:user)
    end

    let(:mail) { NoticeMailer.sendmail_alert(@user) }

    it "renders the headers" do
      mail.subject.should eq("[Troch]Alert")
    end

    it "renders the body" do
      mail.body.encoded.should match("Alert Mail")
    end
  end

end
