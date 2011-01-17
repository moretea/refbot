module FakeIrcBot
  def self.included(klass)
  klass.class_eval do
    attr_reader :channel_messages

    def initialize
      initialize_responders
      clear!
    end

    def clear!
      @channel_messages = ""
      @private_messages = {}
      @action_messages = ""
      @notices = {}
    end

    def message hash, who = "MoreTea", full_name = "Hoogendoorn"
      hash.each do |type, text|
        text << "\r"
        send "#{type.to_s}_message".to_sym, text, who, full_name
      end
    end

    def say_to_chan(msg)
      @channel_messages << (msg + "\n")
    end

    def say_action(msg)
      @action_messages << (msg + "\n")
    end

    def say_to_person(person, msg)
      @private_messages[person] ||= ""
      @private_messages[person] << msg + "\n"
    end

    def notice_to(to, msg)
      @notices[to] ||= ""
      @notices[to] << msg + "\n"
    end

    def notices who
      @notices[who]
    end

    def private_messages who
      @private_messages[who]
    end
  end
  end
end

