# -*- coding: utf-8 -*-
require 'spec_helper.rb'

describe GetPageRank do

  describe "module GooglePageRank" do
    it "m1 should return mix/power mod" do
      GooglePageRank.m1(1, 2, 3, 4).should == 4294967288
    end

    it "c2i should convert char code to int" do
      GooglePageRank.c2i("hello").should == 1819043176
    end

    it "c2i should convert char code to int with k" do
      GooglePageRank.c2i("hello", 2).should == 7302252
    end

    it "checkSum should return" do
      GooglePageRank.checkSum("http://www.google.com").should == 3513778613
    end
  end
end
