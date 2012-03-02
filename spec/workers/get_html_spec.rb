# -*- coding: utf-8 -*-
require 'spec_helper.rb'
require 'base64'

describe GetHtml do
  context 'mechanize' do
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

    describe "get_page_keyword" do
      it "はurlにキーワードが含まれることを確認すること" do
        keyword = get_page_keyword(@page, 'Yahoo!')
        keyword.should == "Yahoo!"
      end

      it "はurlにキーワードが含まれないことを確認すること" do
        keyword = get_page_keyword(@page, 'Wrong Keyword!!!')
        keyword.should_not == "Wrong Keyword!!!"
      end
    end
  end

  it 'get_diff' do
    old_content = Base64.encode64("hello\nworld!\n")
    new_content = Base64.encode64("hello\ndiff-world!\n")
    get_diff(old_content, new_content).should == "- world!\n+ diff-world!\n"
  end
  it 'strip_whiteline' do
    strip_whiteline("hello\n    \nworld!\n").should == "hello\nworld!\n"
  end
end
