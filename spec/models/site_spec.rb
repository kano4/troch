# coding: utf-8
require 'spec_helper'

describe Site, "を生成するとき" do
  before(:each) do
    @name = 'alice'
    @url = 'test@example.com'
  end

  it "は、nameが空の場合バリデーションに失敗すること" do
    @site = Site.new(:name => nil, :url => @url)
    @site.should_not be_valid
  end

  it "は、nameとurlが空でない場合バリデーションに成功すること" do
    @site = Site.new(:name => @name, :url => @url)
    @site.should be_valid
  end
end
