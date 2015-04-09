#!/usr/bin/env ruby
# Encoding: utf-8


## sudo aptitude install libavahi-compat-libdnssd-dev
## sudo gem install technomancy-dnssd -s http://gems.github.com


require 'json'
require "sinatra"
require "sinatra/multi_route"
require 'dnssd'
require 'listen'


set :port, 55060
set :bind, '0.0.0.0'

PATH="/home/server_admin/RemoteDiskServer/DMGs"


route 'GET', '/:discname' do

	puts "#{params[:discname]}"

# 	puts "GET:!!!"
	#puts JSON.pretty_generate(request.env)

	if request.env["HTTP_USER_AGENT"] != "CCURLBS::readDataFork"
	halt 404
	end

	 thestart = 0;
	 theend = 0;
	therange = request.env["HTTP_RANGE"]
	 stringindex = ( therange.index("bytes=")) +6 
	 btyestring = therange[ stringindex..-1]
	 btyestringarray = btyestring.split("-")
	 thestart = btyestringarray[0].to_i
	 theend = btyestringarray[1].to_i
	 

	 length = ( theend- thestart)  + 1
	 puts length
	 thebody = IO.read("#{PATH}/#{params[:discname]}",length, thestart)
	 s = File.new("#{PATH}/#{params[:discname]}").size.to_i

response.headers['Server'] = 'ODS/1.0'
response.headers['Content-Type'] = 'application/octet-stream'

#puts 'bytes ' + thestart.to_s + '-' + (thestart + thebody.bytesize - 1).to_s + '/' + s.to_s

response.headers['Content-Range'] = 'bytes=' + thestart.to_s + '-' + (thestart + thebody.bytesize - 1).to_s + '/' + s.to_s

thebody
	end


route 'HEAD', '/:discname' do
 	puts "HEAD:!!!"
	if request.env["HTTP_USER_AGENT"] != "CCURLBS::statImage"
	halt 404
	end


  s = File.new("#{PATH}/#{params[:discname]}").size
  #puts JSON.pretty_generate(request.env)
  d = Time.now.utc
  #exit
  response.headers['Server'] = 'ODS/1.0'
  response.headers['Date'] = "#{d}"
  response.headers['Content-Type'] = 'application/octet-stream'
  response.headers['Accept-Ranges'] = 'bytes'
  response.headers['Content-Length'] = "#{s}"
  ""
end


def starthere
	tr = DNSSD::TextRecord.new
	#tr["sys"] = "waMA=c4:2c:03:33:85:6a,adVF=0x4"
	tr["sys"] = "waMA=00:50:56:9b:72:03,adVF=0x4"
	#tr['AppleJack-1.6'] = 'adVN=AppleJack-1.6,adVT=public.cd-media'
	#tr['CasperSuite9.6'] = 'adVN=CasperSuite9.6,adVT=public.cd-media'
	#tr['BMPlusv6'] = 'adVN=BM Plus v6,adVT=public.cd-media'


	Dir.entries("#{PATH}/").each do |e|
		if e =~ /dmg/
			discname = (e.rpartition("."))[0]
			puts "Sharing #{discname}"
			tr[discname] = "adVN=#{discname},adVT=public.cd-media"
		end
	end
	DNSSD.register 'Remote Disc Server', '_odisk._tcp', nil, 55060, tr do |r|
  		puts "registered #{r.fullname}" if r.flags.add?
	end

end
starthere()


listener = Listen.to("#{PATH}") do |modified, added, removed|
starthere()
end
listener.start # not blockin
