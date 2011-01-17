require File.dirname(__FILE__) + "/../spec_helper"

describe "Guides" do
  it "should give a link to the general guides" do
    @bot.message :channel=> "userabc: !guides"
    @bot.channel_messages.should include "userabc: See http://refinerycms.com/guides for help with RefineryCMS"
  end

  it "should give a link to the general guides" do
    @bot.message :channel=> "userabc: !guide getting started"
    @bot.channel_messages.should include "userabc: See http://refinerycms.com/guides/getting-started-with-refinery"
  end
end
