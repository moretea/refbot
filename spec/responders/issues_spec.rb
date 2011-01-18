require File.dirname(__FILE__) + "/../spec_helper"

describe "Issues" do
  it "should give a list of the issues" do
    @bot.message :channel => "!issues"
    @bot.channel_messages.should include "issues"
  end
end
