require 'socket'

module SimpleIrcBot
  def initialize(options)
    @server   = options["server"]
    @port     = options["irc_port"]
    @channel  = options["channel"]
    @nick     = options["nick"]
    @password = options["password"]

    @socket = TCPSocket.open(@server, @port)

    say "NICK #{@nick}"
    say "USER #{@nick} 0 * #{@nick}"
    say_to "NickServ", "identify #{@password}"
    say "JOIN ##{@channel}"
    say_to_chan "#{1.chr}ACTION is here to help#{1.chr}"

    @responders = responders
  end

  def responders
    []
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
        p msg if ENV["DEBUG"] == "true"

        if msg.match(/^PING :(.*)$/)
          say "PONG #{$~[1]}"
          next
        end

        if msg.match(/:(.*)!(.*) PRIVMSG ##{@channel} :\001ACTION (.*)\001/)
          action_message $3.chomp.strip, $1, $2
        elsif msg.match(/:(.*)!(.*) PRIVMSG ##{@channel} :(.*)$/)
          channel_message $3.chomp.strip, $1, $2
        elsif msg.match(/:(.*)!(.*) PRIVMSG #{@nick} :(.*)$/)
          private_message $3.chomp.strip, $1, $2
        elsif msg.match(/:(.*)!(.*) JOIN :(.*)$/)
          join $3.chomp.strip, $1, $2
        elsif msg.match(/:(.*)!(.*) NICK :(.*)$/)
          nick $3.chomp.strip, $1, $2
        end
      rescue Exception => e
        if ENV["DEBUG"] == "true"
          p [:exception, e]
          puts  e.backtrace
        end
      end
    end
  end

  def channel_message msg, who, full_name
    p [:channel, msg] if ENV["DEBUG"] == "true"

    @responders.each do |responder|
      responder.channel_message msg, who, full_name
    end
  end

  def private_message msg, who, full_name
    p [:private, msg] if ENV["DEBUG"] == "true"

    @responders.each do |responder|
      responder.private_message msg, who, full_name
    end
  end

  def action_message msg, who, full_name
    p [:action, msg] if ENV["DEBUG"] == "true"

    @responders.each do |responder|
      responder.action_message msg, who, full_name
    end
  end
  def nick msg, who, full_name; end
  def join msg, who, full_name; end
  

  def quit
    say "PART ##{@channel} : It's time to go. Bye!"
    say 'QUIT'
  end
end

