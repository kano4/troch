# coding: utf-8
require 'spec_helper'

describe WatchLog do
  describe "を生成するとき" do
    it "は、statusが空の場合バリデーションに失敗すること" do
      @watch_log = WatchLog.new
      @watch_log.should_not be_valid
    end
  end

  describe "は、delete_old_logsを実行するとき" do
    it "一ヶ月以上前のログを削除すること" do
      @days_ago_log   = WatchLog.new(:status => "ok", :created_at => 3.days.ago).save
      @months_ago_log = WatchLog.new(:status => "ok", :created_at => 3.months.ago).save
      @years_ago_log = WatchLog.new(:status => "ok", :created_at => 3.years.ago).save
      WatchLog.find(:all).size.should == 3
      WatchLog.delete_old_logs
      WatchLog.find(:all).size.should == 1
    end
  end
end
