require 'spec_helper'

describe "sites/show.html.haml" do
  before(:each) do
    @site = assign(:site, stub_model(Site,
      :name => "Name",
      :url => "Url",
      :content => "MyText",
      :domain_url => "Domain Url",
      :ssl_url => "Ssl Url"
    ))
  end
end
