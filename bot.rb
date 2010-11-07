#!/usr/bin/env ruby
require 'rubygems'
require 'octopi'

include Octopi

class Array; def sum; inject(&:+); end; end

project2 = "resolve/refinerycms"
COMPETITORS = {
  'refinery'    => "resolve/refinerycms",
  'radiant'     => "radiant/radiant",
  'zena'        => "zena/zena",
  'adva'        => "svenfuchs/adva_cms",
  'djangocms'   => "divio/django-cms",
  'nesta'       => "gma/nesta",
  'browsercms'  => "browsermedia/browsercms",
  'pyro'        => "pyrocms/pyrocms"
}

def project_info(path)
  repo = Repository.find(:user => path.split("/").first, :repo => path.split("/").last)
  score = repo.forks * 4 + repo.watchers
  stats = {:name => repo.name, :forks => repo.forks, :watchers => repo.watchers, :score => score.to_f}
  begin
    issues = repo.issues
    issue_times = issues.collect { |issue| issue.created_at.to_i }
    avg_issue_time = Time.now - (issue_times.sum / issue_times.count) # It's all seconds

    begin
      gem_downloads  = JSON.load(open("http://rubygems.org/api/v1/gems/#{cms.gem_name}.json").read)['downloads']
    rescue
      gem_downloads = nil
    end

    stats.update({:issue_count => issues.length, :avg_issue_time => seconds_to_days_and_hours(avg_issue_time) })
  rescue Exception => e
    p "-----"
    p "Exception raised while getting the issues:"
    p e.message
    p e.backtrace
    p "-----"
  end

  stats
end

def seconds_to_days_and_hours seconds
  time = Time.at(seconds)
  txt = []

  if (year = time.year - 1970) == 1
    txt << "1y "
  elsif year > 1
    txt << "#{year}y "
  end

  if time.yday > 0
    txt << "#{time.yday}d "
  end

  if time.hour > 0
    txt << "#{time.hour}h "
  end

  txt
end

def compare_projects(project1, project2)
  project1_info = project_info(project1)
  project2_info = project_info(project2)
  if (proportion = project1_info[:score] / project2_info[:score]) > 1
    proportion **= -1
    project1, project2 = project2, project1
  end

  { :project1 => project1_info, :project2 => project2_info, :score => ((proportion * 10000).round / 100.0).to_s + "%" }
end



require 'socket'


class SimpleIrcBot

  def initialize(server, port, channel, nick)
    @channel = channel
    @nick = nick
    @socket = TCPSocket.open(server, port)
    say "NICK #{@nick}"
    say "USER #{@nick} 0 * #{@nick}"
    say_to "NickServ", "identify R3finerie"
    say "JOIN ##{@channel}"
    say_to_chan "#{1.chr}ACTION is here to help#{1.chr}"
  end

  def say_to_chan(msg)
    say_to "##{@channel}", msg
  end

  def say_to_person(person, msg)
    say_to person, msg
  end

  def say_to(to, msg)
    say "PRIVMSG #{to} :#{msg}"
  end

  def notice_to(to, msg)
    say "NOTICE #{to} :#{msg}"
  end

  def say(msg)
    puts msg
    @socket.puts msg
  end

  def run
    until @socket.eof? do
      begin
        msg = @socket.gets
        puts msg if ENV["DEBUG"] == "true"

        if msg.match(/^PING :(.*)$/)
          say "PONG #{$~[1]}"
          next
        end

        if msg.match(/:(.*)!(.*) PRIVMSG ##{@channel} :(.*)$/)
          channel_message $3, $1, $2
        elsif msg.match(/:(.*)!(.*) PRIVMSG #{@nick} :(.*)$/)
          private_message $3, $1, $2
        elsif msg.match(/:(.*)!(.*) JOIN :(.*)$/)
          join $3, $1, $2
        elsif msg.match(/:(.*)!(.*) NICK :(.*)$/)
          nick $3.chomp.strip, $1, $2
        end
      rescue Exception => e
        p [:exception, e] if ENV["DEBUG"] == "true"
      end
    end
  end

  def quit
    say "PART ##{@channel} : It's time to go. Bye!"
    say 'QUIT'
  end
end

class RefineryBot < SimpleIrcBot

  def channel_message msg, who, full_name
    p [:channel, msg] if ENV["DEBUG"] == "true"

    if msg =~ /(.*): (pastie please|post a pastie| can you post a pastie)/
      notice_to $1, "#{who} requested that you'd post a pastie. Please go to http://pastie.org/pastes/new"
    elsif msg =~ /^refinery status/
      stat_chan who
    elsif msg =~ /^compare (.*) vs (.*)/
      p1 = $1.chomp.strip
      p2 = $2.chomp.strip

      if COMPETITORS.has_key? p1
        if COMPETITORS.has_key? p2
          compare_frameworks_chan p1, p2
        end
      end
    end
  end

  def private_message msg, who, full_name
    if msg =~/^help/
      notice_to who, "Refbot responds to the following commands in the channel"
      notice_to who, "  refinery status          Print statistics about refinery"
      notice_to who, "  compare <CMS1> vs <CMS2> Compare the 'popularity' of two CMS's"
      notice_to who, "  <USER>: pastie please        \\"
      notice_to who, "  <USER>: post a pastie         |=> Send pastie request"
      notice_to who, "  <USER>: can you post a pastie /"
      notice_to who, "Refbot responds to the following commands in a private message"
      notice_to who, "  refinery status          Print statistics about refinery"
      notice_to who, "  compare <CMS1> vs <CMS2> Compare the 'popularity' of two CMS's"
      notice_to who, "  compare list             Shows a list of comparable cms's"
    elsif msg =~ /^compare list/
      notice_to who, "Available CMS'es: " + COMPETITORS.keys.sort.join(", ")
    elsif msg =~ /^refinery status/
      stat_priv who
    elsif msg =~ /^compare (.*) vs (.*)/
      p1 = $1.chomp.strip
      p2 = $2.chomp.strip

      if COMPETITORS.has_key? p1
        if COMPETITORS.has_key? p2
          compare_frameworks_priv p1, p2, who
        end
      end
    else
      notice_to who, "Try /msg #{@nick} help."
    end
  end

  def join channel, who, fullname
    notice_to who, "Welcome to refinerycms. Don't hesitate to ask your questions!"
  end

  def nick new_nick, old_nick, fullname
    p [:nick, new_nick, old_nick, fullname] if ENV["DEBUG"] == "true"
  end

  def stat_chan who
    stat = project_info("resolve/refinerycms")
    say_to_chan "#{who} asked about the refinery stats:"
    say_to_chan "  Forks             : %4d" % stat[:forks]
    say_to_chan "  Watchers          : %4d" % stat[:watchers]
    say_to_chan "  Open issues       : %4d" % stat[:issue_count]
    say_to_chan "  Average time open : %s"   % stat[:avg_issue_time]
  end

  def stat_priv who
    stat = project_info("resolve/refinerycms")
    notice_to who, "  Forks             : %4d" % stat[:forks]
    notice_to who, "  Watchers          : %4d" % stat[:watchers]
    notice_to who, "  Open issues       : %4d" % stat[:issue_count]
    notice_to who, "  Average time open : %s"   % stat[:avg_issue_time]
  end


  def compare_frameworks_chan a,b
    result = compare_projects COMPETITORS[a], COMPETITORS[b]
    p result
    say_to_chan "Comparing #{result[:project1][:name]} with #{result[:project2][:name]}"
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
      say_to_chan output
    end
    say_to_chan "  RubyToolbox Score: " + result[:score]
  end

  def compare_frameworks_priv a,b, who
    result = compare_projects COMPETITORS[a], COMPETITORS[b]
    p result
    notice_to who, "Comparing #{result[:project1][:name]} with #{result[:project2][:name]}"
    notice_to who, "  %-20s forks: %4d, watchers: %4d, open issues: %4d, average time open: %s" % [result[:project1][:name], result[:project1][:forks], result[:project1][:watchers], result[:project1][:issue_count], result[:project1][:avg_issue_time]]
    notice_to who, "  %-20s forks: %4d, watchers: %4d, open issues: %4d, average time open: %s" % [result[:project2][:name], result[:project2][:forks], result[:project2][:watchers], result[:project2][:issue_count], result[:project2][:avg_issue_time]]
    notice_to who, "  RubyToolbox Score: " + result[:score]
  end
end

bot = RefineryBot.new("irc.freenode.net", 6667, 'refinerycms', "RefBot")

trap("INT"){ bot.quit }

bot.run
