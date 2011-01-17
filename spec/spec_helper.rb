ENV["BOT_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../boot.rb"
RefineryBot.send :include, FakeIrcBot

Dir[BOT_PATH.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.before(:all) do
   RefineryBot.send :include, FakeIrcBot
   @bot = RefineryBot.new
  end

  config.before(:each) do
   @bot.clear!
  end
end
