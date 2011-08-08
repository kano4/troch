# coding: utf-8
require 'spec_helper'

describe WatchLog, "を生成するとき" do
  it "は、statusが空の場合バリデーションに失敗すること" do
    @watch_log = WatchLog.new
    @watch_log.should_not be_valid
  end
end
