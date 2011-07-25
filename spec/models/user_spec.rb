# coding:utf-8
require 'spec_helper'

describe User do
  it "は正常保存できること" do
    @user = Factory(:alice)
    @user.save.should be_true
  end

  it "アリスはSiteを2つ持っていること" do
    @alice = Factory(:alice)
    @alice.should have(2).sites
  end
  it "ボブはSiteを1つ持っていること" do
    @bob = Factory(:bob)
    @bob.should have(1).sites
  end
end
