require 'spec_helper'

describe PagesController do
  describe "GET 'index'" do
    it "should be successful" do
      @user = FactoryGirl.create(:user)
      sign_in @user
      get :index
      response.should be_success
    end

    it "should not be successful" do
      get :index
      response.should_not be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      @user = FactoryGirl.create(:user)
      sign_in @user
      get :edit
      response.should be_success
    end

    it "should not be successful" do
      get :edit
      response.should_not be_success
    end
  end

  describe "GET 'log'" do
    it "should be successful" do
      @user = FactoryGirl.create(:user)
      sign_in @user
      get :log
      response.should be_success
    end

    it "should not be successful" do
      get :log
      response.should_not be_success
    end
  end

  describe "GET 'alert'" do
    it "should be successful" do
      @user = FactoryGirl.create(:user)
      sign_in @user
      get :alert
      response.should be_success
    end

    it "should not be successful" do
      get :alert
      response.should_not be_success
    end
  end

  describe "within_1hour?" do
    it "should be true when record_time is within 1hour" do
      record_time = (Time.now - 30.minutes).to_s
      within_1hour?(record_time).should be_true
    end
    it "should not be true when record_time is not within 1hour" do
      record_time = (Time.now - 1.hour).to_s
      within_1hour?(record_time).should_not be_true
    end
  end

end
