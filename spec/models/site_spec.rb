# coding: utf-8
require 'spec_helper'

describe Site, "を生成するとき" do
  before(:each) do
    @name = 'Sample site'
    @watch_method = 'html_body'
  end

  it "は、nameが空の場合バリデーションに失敗すること" do
    @site = Site.new(:name => nil, :watch_method => @watch_method)
    @site.should_not be_valid
  end

  it "は、nameとwatch_methodが空の場合バリデーションに失敗すること" do
    @site = Site.new(:name => nil, :watch_method => nil)
    @site.should_not be_valid
  end

  it "は、nameとwatch_methodが空でない場合バリデーションに成功すること" do
    @site = Site.new(:name => @name, :watch_method => @watch_method)
    @site.should be_valid
  end
end
