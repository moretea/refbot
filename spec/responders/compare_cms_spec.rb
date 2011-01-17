require File.dirname(__FILE__) + "/../spec_helper"

describe "CMS compare responder" do
  it "should compare CMS'es, when asked to do so" do
    @bot.message :channel => "!compare refinery with radiant"
    @bot.channel_messages.should include "Comparing refinerycms with radiant"

    @bot.clear!

    @bot.message :private => "!compare refinery with radiant"
    @bot.notices("MoreTea").should include "Comparing refinerycms with radiant"
  end
  
  it "should return a list of cmses" do
    @bot.message :private => "!compare list"
    @bot.notices("MoreTea").should include "Available CMS'es:"
  end
end
