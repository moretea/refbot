require File.dirname(__FILE__) + "/../spec_helper"

describe "Gist responder" do
  it "should instruct a user how to post a gist" do
    @bot.message :channel => "userabc: !gist"
    @bot.channel_messages.should include "userabc: Please use gist (https://gist.github.com/) to paste your code"
    @bot.clear!
    @bot.message :channel => "userabc: !gist stacktrace"
    @bot.channel_messages.should include "userabc: Please use gist (https://gist.github.com/) to paste your stacktrace"
  end
end
