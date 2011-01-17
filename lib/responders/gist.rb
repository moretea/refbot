class Responders::Pastie < Responders::Base
  def channel_message msg, who, full_name
    case msg
      when /([^:,]*)(:|,|)? !gist(.*)$/
        what = ($3.chomp.blank? ? "code" : $3.chomp.strip)
        say_to_chan "#{$1}: Please use gist (https://gist.github.com/) to paste your #{what}"
    end
  end
end
