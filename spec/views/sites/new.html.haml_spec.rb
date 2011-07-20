require 'spec_helper'

describe "sites/new.html.haml" do
  before(:each) do
    assign(:site, stub_model(Site,
      :name => "MyString",
      :url => "MyString",
      :content => "MyText",
      :domain_url => "MyString",
      :ssl_url => "MyString"
    ).as_new_record)
  end

  it "renders new site form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sites_path, :method => "post" do
      assert_select "input#site_name", :name => "site[name]"
      assert_select "input#site_url", :name => "site[url]"
      assert_select "textarea#site_content", :name => "site[content]"
      assert_select "input#site_domain_url", :name => "site[domain_url]"
      assert_select "input#site_ssl_url", :name => "site[ssl_url]"
    end
  end
end
