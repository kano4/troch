require 'spec_helper'

describe "pages/index.html.haml" do
  it "should have h1 tag" do
    render
    render.should have_selector('h1', :content => 'Troch')
  end
end
