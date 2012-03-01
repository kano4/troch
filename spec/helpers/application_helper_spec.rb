# -*- coding: utf-8 -*-
require 'spec_helper'

describe ApplicationHelper do
  it 'copyright' do
    copyright.should == 'Powered by Troch'
  end
end
