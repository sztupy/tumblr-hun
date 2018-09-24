#!/usr/bin/env ruby

require 'json'

source = JSON.parse(`tail -n 1 numbers.dat`)

# remove blogs whose Hungarian content has been reblogged less than 20 times
source.delete_if {|k,v| !v['trail_hun'] || v['trail_hun'] < 20 }

File.open("numbers.filtered.json","w+") do |out|
  out.puts JSON.generate(source)
end