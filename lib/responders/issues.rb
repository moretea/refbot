class Responders::Issues < Responders::Base
  include Octopi

  def channel_message msg, who, full_name
    case msg
      when /^!issues$/
        repo = Repository.find(:user => "resolve", :repo => "refinerycms")
        repo.issues.each do |issue|
          print_issue issue
        end
      when /^!issue (\d+)$/
        repo = Repository.find(:user => "resolve", :repo => "refinerycms")
        issue = repo.issues.select { |issue| issue.number == $1.to_i }.first
        print_issue issue
    end
  end

  def print_issue issue
    age = CmsComparer.seconds_to_days_and_hours(issue.created_at, false)
    say_to_chan " #{age} - #{issue.title} - https://github.com/resolve/refinerycms/issues/#{issue.number}"
  end
end
