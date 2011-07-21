require 'spec_helper'

describe Site do
  it "must have a name" do
    site = Site.create
    site.errors[:name].should_not be_empty
  end
end
