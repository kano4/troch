# coding: utf-8
require 'spec_helper'
require 'fileutils'

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
    before(:each) do
      @site = Factory(:site)
      @site.save
      @expected = [Site.first]

      @user = Factory(:user)
      @user.save
      @expected_user = [User.first]
    end

    it '.get_domain_expiredは各Siteごとに実行されること' do
      Site.get_domain_expired.should == @expected
    end

    it '.get_ssl_expiredは各Siteごとに実行されること' do
      Site.get_ssl_expired.should == @expected
    end

    it '.get_page_rankは各Siteごとに実行されること' do
      Site.get_page_rank.should == @expected
    end

    describe '.get_html' do
      it 'はtmp/cron/cron.onが存在する場合は各Siteごとに実行されること' do
        if File.exist?("#{Rails.root}/tmp/cron/cron.on")
          Site.get_html.should == @expected
        else
          FileUtils.mkdir_p("#{Rails.root}/tmp/cron")
          File.write("#{Rails.root}/tmp/cron/cron.on", '')
          Site.get_html.should == @expected
          File.delete("#{Rails.root}/tmp/cron/cron.on")
        end
      end

      it 'はtmp/cron/cron.onが存在しない場合は何もしないこと' do
        if File.exist?("#{Rails.root}/tmp/cron/cron.on")
          File.delete("#{Rails.root}/tmp/cron/cron.on")
          Site.get_html.should == nil
          File.write("#{Rails.root}/tmp/cron/cron.on", '')
        else
          Site.get_html.should == nil
        end
      end
    end

    it '.send_summaryは各Userごとに実行されること' do
      Site.send_summary.should == @expected_user
    end
  end
end
