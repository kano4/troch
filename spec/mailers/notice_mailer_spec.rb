require "spec_helper"

describe NoticeMailer do
  describe "sendmail_alert" do
    let(:mail) { NoticeMailer.sendmail_alert }

    it "renders the headers" do
      mail.subject.should eq("[Troch]Alert")
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
