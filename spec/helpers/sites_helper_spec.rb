# -*- coding: utf-8 -*-
require 'spec_helper'

describe SitesHelper do
  it 'html_body' do
    html_body.should == 'HTML差分監視'
  end
  it 'html_title' do
    html_title.should == 'TITLEタグ差分監視'
  end
  it 'html_keyword' do
    html_keyword.should == 'キーワード有無監視'
  end
end
