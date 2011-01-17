require "net/http"

class Responders::Guides < Responders::Base
  def initialize *args
    super *args
    @last_update_at = 0 
  end

  def channel_message msg, who, full_name
    case msg
      when /^(.*)(:,)? !guides$/
        say_to_chan "#{$1} See http://refinerycms.com/guides for help with RefineryCMS"
      when /^(.*)(:,)? !guide (.*)$/
        guide = find_guide $3
        if guide.nil?
          say_to_chan "#{who}, guide \"#{$3}\" not found :("
        else
          say_to_chan "#{$1} See #{guide["url"]}"
        end
    end
  end

protected

  def find_guide excerpt
    regexp = /#{excerpt}/i
    guides.each do |guide|
      return guide if guide["title"] =~ regexp
    end

    nil
  end

  def guides
    if (Time.now.to_i - @last_update_at) > 5 * 60 # five minutes
      @guides = JSON::load(Net::HTTP.get("refinerycms.com", "/guides.json")).collect { |item| item["guide"] }
    end
    @guides
  end
end
