require 'rubygems'

unless defined?(BOT_ENV)
  BOT_ENV = ENV['BOT_ENV'] || 'development'
end

begin
  ENV['BUNDLE_GEMFILE'] = "Gemfile"
  require 'bundler'
  Bundler.setup
  Bundler.require(:default, BOT_ENV)
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end

BOT_PATH = Pathname.new(__FILE__).parent.parent
files = %w{
  simple_bot
  fake_irc_bot
  ref_bot

  responders/base
  responders/help
  responders/gist
  responders/refinery_status
  responders/comparer
  responders/cookie
  responders/ask
  responders/guides

  cms_comparer
}

files.map { |file| require BOT_PATH.join("lib", file) }

$options = YAML::load(File.read(BOT_PATH.join("config", "config.yml")))

COMPETITORS = $options["cmses"]
