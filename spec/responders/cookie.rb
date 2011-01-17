require File.dirname(__FILE__) + "/../spec_helper"

describe "Cookie" do
  it "should not be happy with cookies" do
    @bot.message :action => "gives the bot a cookie"
    @bot.channel_messages.should include "I'd rather have a contribution to Refinery"
  end
end
