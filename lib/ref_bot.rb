class RefineryBot 
  include SimpleIrcBot

  def initialize_responders
    @responders = []
    @responders << Responders::Pastie.new(self)
    @responders << Responders::RefineryStatus.new(self)
    @responders << Responders::Comparer.new(self)
    @responders << Responders::Help.new(self)
    @responders << Responders::Cookie.new(self)
  end

  def channel_message msg, who, full_name
    p [:channel, msg] if ENV["DEBUG"] == "true"

    @responders.each do |responder|
      responder.channel_message msg, who, full_name
    end
  end

  def private_message msg, who, full_name
    p [:private, msg] if ENV["DEBUG"] == "true"

    @responders.each do |responder|
      responder.private_message msg, who, full_name
    end
  end

  def action_message msg, who, full_name
    p [:action, msg] if ENV["DEBUG"] == "true"

    @responders.each do |responder|
      responder.action_message msg, who, full_name
    end
  end

  def join channel, who, fullname
    notice_to who, "Welcome to refinerycms. Don't hesitate to ask your questions!"
  end

  def nick new_nick, old_nick, fullname
    p [:nick, new_nick, old_nick, fullname] if ENV["DEBUG"] == "true"
  end
end
