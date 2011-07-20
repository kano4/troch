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

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Url/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Domain Url/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Ssl Url/)
  end
end
