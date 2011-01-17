
require File.dirname(__FILE__) + "/../spec_helper"

describe "Help!" do
  it "should send notices with the help text" do
    @bot.message :private => "help"
    @bot.notices("MoreTea").should include "Refbot responds to the following commands"
  end
end
