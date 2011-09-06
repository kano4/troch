require 'spec_helper'

describe PagesController do
  describe "GET 'index'" do
    it "should be successful" do
      @user = Factory(:user)
      sign_in @user
      get :index
      response.should be_success
    end

    it "should not be successful" do
      get :index
      response.should_not be_success
    end
  end

end
