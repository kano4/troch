# coding: utf-8
require 'spec_helper'

describe Site do
  before(:each) do
    @user = Factory(:user)
    @name = 'Sample site'
    @watch_method = 'html_body'
  end

  context 'registration' do
    it "は、nameとwatch_methodが空でない場合バリデーションに成功すること" do
      @site = Site.new(:name => @name, :watch_method => @watch_method)
      @site.should be_valid
    end

    it "は、nameが空の場合バリデーションに失敗すること" do
      @site = Site.new(:name => nil, :watch_method => @watch_method)
      @site.should_not be_valid
    end

    it "は、watch_methodが空の場合バリデーションに失敗すること" do
      @site = Site.new(:name => @name, :watch_method => nil)
      @site.should_not be_valid
    end

    it "は、nameとwatch_methodが空の場合バリデーションに失敗すること" do
      @site = Site.new(:name => nil, :watch_method => nil)
      @site.should_not be_valid
    end
  end

  context 'class method' do
    before(:each) do
      @site = Factory(:site)
      @site.save
    end

    it '.get_domain_expiredを持つこと' do
      Site.get_domain_expired.should be_true
    end

    it '.get_ssl_expiredを持つこと' do
      Site.get_ssl_expired.should be_true
    end

    it '.get_page_rankを持つこと' do
      Site.get_page_rank.should be_true
    end

    it '.get_htmlを持つこと' do
      Site.get_html.should be_true
    end

    it '.send_summaryを持つこと' do
      Site.send_summary.should be_true
    end
  end
end
