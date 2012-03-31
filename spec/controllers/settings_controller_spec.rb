require 'spec_helper'

describe SettingsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'watch_on_off'" do
    it "should be successful" do
      get :watch_on_off
      response.should be_success
    end
  end

end
