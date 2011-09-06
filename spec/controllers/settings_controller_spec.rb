require 'spec_helper'

describe SettingsController do
  before(:each) do
    @user = Factory(:user)
    sign_in @user
  end

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'watch_interval'" do
    it "should be successful" do
      get :watch_interval
      response.should be_success
    end
  end

end
