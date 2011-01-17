class Responders::Ask< Responders::Base
  def channel_message msg, who, full_name
    case msg
      when /^(.*)(:,)? !ask/
        say_to_chan "#{$1} Just ask your question! If someone knows the answer, you'll probably get it"
      when /^(.*)(:,)? !howto ask/
        say_to_chan "#{$1} http://www.catb.org/~esr/faqs/smart-questions.html"
    end
  end
end
