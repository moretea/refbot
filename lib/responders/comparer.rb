class Responders::Comparer < Responders::Base
  def channel_message msg, who, full_name
    case msg
      when /^!compare (.*) with (.*)/
        compare_frameworks($1, $2).each do |line|
          say_to_chan line
        end
    end
  end

  def private_message msg, who, full_name
    case msg
      when /^!compare list/
        notice_to who, "Available CMS'es: " + COMPETITORS.keys.sort.join(", ")
      when /^!compare (.*) with (.*)/
        compare_frameworks($1, $2).each do |line|
          notice_to who, line
        end
    end
  end

  def compare_frameworks a, b
    lines = []
    result = CmsComparer.compare_projects a, b
    lines << "Comparing #{result[:project1][:name]} with #{result[:project2][:name]}"
    [result[:project1], result[:project2]].each do |project|
      output = "  %-20s " % project[:name]
      output << ("forks: %4d") % project[:forks] unless project[:forks].to_s.blank?
      output << (", watchers: %4d") % project[:watchers] unless project[:watchers].to_s.blank?
      if project.keys.include?(:issue_count)
        output << (", open issues: %4d") % project[:issue_count]
        output << (", average time open: %s") % project[:avg_issue_time] if project.keys.include?(:avg_issue_time)
      else
        output << ", no open issues!"
      end
      lines << output
    end
    lines << "  RubyToolbox Score: " + result[:score]

    lines
  end
end
