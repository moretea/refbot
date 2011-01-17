class Responders::Ask< Responders::Base
  def channel_message msg, who, full_name
    if msg =~ /^(.*)(:,)? !ask/
      say_to_chan "#{$1} Just ask your question! If someone knows the answer, you'll probably get it"
    elsif msg =~ /^(.*)(:,)? !howto ask/
      say_to_chan "#{$1} http://www.catb.org/~esr/faqs/smart-questions.html"
    end
  end
end
