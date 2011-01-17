#!/usr/bin/env ruby
require File.expand_path("config/boot")

$bot = RefineryBot.new($options['bot']) 
trap("INT"){ $bot.quit }

$bot.run
