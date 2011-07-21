require 'spec_helper'

describe "sites/edit.html.haml" do
  before(:each) do
    @site = assign(:site, stub_model(Site,
      :name => "SiteName",
      :url => "MyString",
      :content => "MyText",
      :domain_url => "MyString",
      :ssl_url => "MyString"
    ))
  end
end
