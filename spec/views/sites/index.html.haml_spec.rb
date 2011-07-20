require 'spec_helper'

describe "sites/index.html.haml" do
  before(:each) do
    assign(:sites, [
      stub_model(Site,
        :name => "Name",
        :url => "Url",
        :content => "MyText",
        :domain_url => "Domain Url",
        :ssl_url => "Ssl Url"
      ),
      stub_model(Site,
        :name => "Name",
        :url => "Url",
        :content => "MyText",
        :domain_url => "Domain Url",
        :ssl_url => "Ssl Url"
      )
    ])
  end

  it "renders a list of sites" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Domain Url".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Ssl Url".to_s, :count => 2
  end
end
