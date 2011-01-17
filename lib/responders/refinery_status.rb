class Responders::RefineryStatus< Responders::Base
  def channel_message msg, who, full_name
    case msg
      when /^!status (.*)/
        say_to_chan "#{who} asked about the refinery stats:"
        stat_chan($1).each do |line|
          say_to_chan line
        end
    end
  end

  def private_message msg, who, full_name
    case msg
      when /^!status (.*)/
        stat_chan($1).each do |line|
          notice_to who, line
        end
    end
  end

  def stat_chan cms
    cms.chomp!
    cms.strip!

    lines = []
    return lines << "No such cms" unless CmsComparer.competitor_names.include? cms
    stat = CmsComparer.project_info(cms)
    lines << "  Forks             : %4d" % stat[:forks]
    lines << "  Watchers          : %4d" % stat[:watchers]
    lines << "  Open issues       : %4d" % stat[:issue_count]
    lines << "  Average time open : %s"   % stat[:avg_issue_time]
  end
end
