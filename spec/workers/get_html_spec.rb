# -*- coding: utf-8 -*-
require 'spec_helper.rb'

describe GetHtml do
  before(:each) do
    @page = Mechanize.new.get("http://www.yahoo.co.jp")
  end

  describe "get_page_title" do
    it "はurlが有効な時、正しいタイトルを取得すること" do
      title = get_page_title(@page)
      title.should == "Yahoo! JAPAN"
    end

    it "はurlが有効な時、正しくないタイトルを取得しないこと" do
      title = get_page_title(@page)
      title.should_not == "Google"
    end
  end
end
