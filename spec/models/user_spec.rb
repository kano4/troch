# coding:utf-8
require 'spec_helper'

describe User do
  before(:each) do
    @user = Factory(:user)
  end

  context "はユーザ登録する場合" do
    it "emailとpasswordが正常なら保存できること" do
      @user.save.should be_true
    end
    it "emailが空なら保存に失敗すること" do
      @user.email = ''
      @user.save.should_not be_true
    end
    it "passwordが空なら保存に失敗すること" do
      @user.password = ''
      @user.save.should_not be_true
    end
    it "passwordが6文字未満なら保存に失敗すること" do
      @user.password = '12345'
      @user.save.should_not be_true
    end
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
