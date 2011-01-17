require File.dirname(__FILE__) + "/../spec_helper"

describe "Questions" do
  it "Users should ask real questions" do
    @bot.message :channel=> "userabc: !ask"
    @bot.channel_messages.should include "userabc: Just ask your question! If someone knows the answer, you'll probably get it"
  end

  it "should give a link to the general guides" do
    @bot.message :channel=> "userabc: !howto ask"
    @bot.channel_messages.should include "userabc: http://www.catb.org/~esr/faqs/smart-questions.html"
  end
end
