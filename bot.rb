#!/usr/bin/env ruby
require File.expand_path("boot")
$bot = RefineryBot.new($options['bot']) 
trap("INT"){ $bot.quit }

$bot.run
