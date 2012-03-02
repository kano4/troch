# coding: utf-8
require 'spec_helper'

describe Site do
  before(:each) do
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
    it '.get_domain_expiredを持つこと' do
      Site.should respond_to(:get_domain_expired)
    end

    it '.get_ssl_expiredを持つこと' do
      Site.should respond_to(:get_ssl_expired)
    end

    it '.get_page_rankを持つこと' do
      Site.should respond_to(:get_page_rank)
    end

    it '.get_htmlを持つこと' do
      Site.should respond_to(:get_html)
    end

    it '.send_summaryを持つこと' do
      Site.should respond_to(:send_summary)
    end
  end
end
