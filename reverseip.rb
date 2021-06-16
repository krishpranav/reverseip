#!/usr/bin/env ruby

# requires
require 'json'
require 'colorize'
require 'net/http'
require 'mechanize'

sep    = ('-'*100).colorize(:cyan)
leets  = ['T3N38R15', 'MakMan', 'Maini', 'MithaiWala' 'IPLOOKUP']


puts 'REVERSEIP'.colorize(:yellow)
puts sep

print 'IP/Domain --> '.colorize(:red)
ip = gets.chomp

json   = Mechanize.new.post('https://domains.yougetsignal.com/domains.php', { 'remoteAddress' => ip, 'key' => '' }, 'Content-type' => 'application/x-www-form-urlencoded').body
parsed = JSON.parse(json)
puts sep