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


# status code function
def statusCode(site)
    response = ''
    begin
        Net::HTTP.start(site, 80) {|http|
                response = http.head('/')
        }
        return response.code.colorize(:yellow)
    rescue StandartError
        return '???'.colorize(:red)
    end
end


def getCMS(site)
    cms = ''
    begin
        cms  = Mechanize.new.get('http://' + site).at('meta[name="generator"]')[:content][0..50]
        return ' -- ' + '[ '.colorize(:cyan) + cms.to_s.colorize(:yellow) + ' ]'.colorize(:cyan)
    rescue StandartError; end
end

if parsed['status'] == 'failure' || parsed['status'] == 'failure'
	abort('[!] '.colorize(:red) + parsed['message'].split('. ')[0] + "\n#{sep}\n")
else
	puts 'Target            -- '.colorize(:red) + parsed['remoteIpAddress']
	puts 'Number of Domains -- '.colorize(:red) + parsed['domainCount']; len = parsed['domainCount'].length
	puts sep

	domains = parsed['domainArray']
	puts 'Domains -- '.colorize(:red)
	domains.each.with_index(1) {|domain, index|
		dashes     = '-' * (domains.flatten.max_by(&:size).length - domain[0].length + 1) + ' '
		httpStatus = statusCode(domain[0])
		
		print '[ '.colorize(:cyan) + index.to_s.rjust(len, '0').colorize(:red) + ' ]'.colorize(:cyan) + ' -- '
		print '[ '.colorize(:cyan) + domain[0].to_s.colorize(:green) + ' ] '.colorize(:cyan) + dashes.to_s
		print '[ '.colorize(:cyan) + httpStatus.to_s + ' ]'.colorize(:cyan)
		puts getCMS(domain[0])
	}
end
puts sep