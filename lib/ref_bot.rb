class RefineryBot 
  include SimpleIrcBot

  def responders 
    [
      Responders::Pastie.new(self),
      Responders::RefineryStatus.new(self),
      Responders::Comparer.new(self),
      Responders::Help.new(self),
      Responders::Cookie.new(self),
      Responders::Ask.new(self),
      Responders::Guides.new(self),
    ]
  end

  def join channel, who, fullname
    notice_to who, "Welcome to #refinerycms. Don't hesitate to ask your questions!"
  end
end
