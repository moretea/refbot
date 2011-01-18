require 'octopi'

module CmsComparer
  include Octopi
  REFINERY = "resolve/refinerycms"

  def self.competitor_names
    @@competitor_names ||= COMPETITORS.keys
  end

  def self.status(name)
    return nil unless competitor_names.member?(name)
    raise project_info(name).inspect
  end

  def self.compare_projects(project1, project2)
    project1.chomp!
    project2.chomp!
    return unless competitor_names.member?(project1) && competitor_names.member?(project2)
    project1_info = project_info(project1)
    project2_info = project_info(project2)
    proportion = project1_info[:score] / project2_info[:score]

    { :project1 => project1_info, :project2 => project2_info, :score => ((proportion * 10000).round / 100.0).to_s + "%" }
  end


  def self.project_info(name)
    path = COMPETITORS[name]
    repo = Repository.find(:user => path.split("/").first, :repo => path.split("/").last)
    latest_version = repo.tags.collect { |tag| tag.name }.sort.reverse.first
    score = repo.forks * 4 + repo.watchers
    stats = {:name => repo.name, :forks => repo.forks, :watchers => repo.watchers, :score => score.to_f, :latest_version => latest_version}
    begin
      issues = repo.issues
      issue_times = issues.collect { |issue| issue.created_at.to_i }
      avg_issue_time = Time.now - (issue_times.reduce{ |a,b| a + b} / issue_times.count) # It's all seconds
      begin
        gem_downloads  = JSON.load(open("http://rubygems.org/api/v1/gems/#{cms.gem_name}.json").read)['downloads']
      rescue Exception => if_this_failed_no_worries
        gem_downloads = nil
      end
      stats.update({:issue_count => issues.length, :avg_issue_time => seconds_to_days_and_hours(avg_issue_time) })
    rescue Exception => e
      raise if BOT_ENV == "test"
      p "-----"
      p "Exception raised while getting the issues:"
      p e.message
      p e.backtrace
      p "-----"
    end

    stats
  end
 
  def self.seconds_to_days_and_hours seconds, since_unix_epoch = true
    txt = []
    if since_unix_epoch
      time = Time.at(seconds)
    else
      time = Time.at(Time.now - Time.at(seconds))
    end

    year = time.year - 1970

    if year > 0
      txt << "#{year}y"
    end

    if time.yday > 0
      txt << "#{time.yday}d"
    end

    if time.hour > 0
      txt << "#{time.hour}h"
    end

    txt.join " "
  end
end
