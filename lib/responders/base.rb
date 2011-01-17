module Responders
  ALL = []
  class Base
    def initialize(bot)
      @bot = bot
    end

    def channel_message msg, who, full_name; end
    def private_message msg, who, full_name; end
    def action_message msg, who, full_name; end

    def notice_to *args
      @bot.notice_to *args 
    end

    def say_to_chan *args
      @bot.say_to_chan *args
    end
  end
end
