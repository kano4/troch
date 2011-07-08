require 'spec_helper'

describe "pages/index.html.haml" do
  it "should have h2 tag" do
    render
    render.should have_selector('h2', :content => 'Troch')
  end
end
