class Responders::Help < Responders::Base
  def private_message msg, who, full_name
    case msg
      when /^help/
        print_help who
    end
  end

  def print_help who
    notice_to who, "Refbot responds to the following commands in the channel"
    notice_to who, "  !status <CMS>               Print statistics about refinery"
    notice_to who, "  !compare <CMS1> with <CMS2> Compare the 'popularity' of two CMS's"
    notice_to who, "  <USER>: !gist <REASON>      Instructs <USER> to use a gist. <REASON> is optional"
    notice_to who, "Refbot responds to the following commands in a private message"
    notice_to who, "  !status <CMS>               Print statistics about refinery"
    notice_to who, "  !compare <CMS1> with <CMS2> Compare the 'popularity' of two CMS's"
    notice_to who, "  !compare list               Shows a list of comparable cms's"
    notice_to who, "The source can be found at https://github.com/moretea/refbot/"
  end
end
