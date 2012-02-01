# coding: utf-8
require 'spec_helper'

describe Group, "を生成するとき" do
  it "は、nameが空の場合バリデーションに失敗すること" do
    @group = Group.new(:name => nil)
    @group.should_not be_valid
  end

  it "は、nameが空でない場合バリデーションに成功すること" do
    @group = Group.new(:name => 'group name')
    @group.should be_valid
  end
end
