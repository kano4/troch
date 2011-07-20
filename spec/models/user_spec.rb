require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :email => "test@example.com",
      :password => "passwd",
      :password_confirmation => "passwd"
    }
  end

  it "should require an email address" do
    true
  end
end
