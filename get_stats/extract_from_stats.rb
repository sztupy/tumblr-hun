#!/usr/bin/env ruby

require 'json'

source = JSON.parse(File.read("numbers.filtered.json"))

puts "Hungarian content appears in trail"
puts "----------------------------------"

source.to_a.sort_by{|s| -s[1]['trail_hun'] || 0}.take(1000).each_with_index do |s,i|
  puts "#{i+1}. #{s[0]}: #{s[1]['trail_hun']}"
end

puts
puts
puts "Hungarian content appears as the root content"
puts "---------------------------------------------"

source.to_a.sort_by{|s| -(s[1]['trail_root_hun'] || 0)}.take(1000).each_with_index do |s,i|
  puts "#{i+1}. #{s[0]}: #{s[1]['trail_root_hun']}"
end

puts
puts
puts "Is reblogged from"
puts "-----------------"

source.to_a.sort_by{|s| -(s[1]['from'] || 0)}.take(1000).each_with_index do |s,i|
  puts "#{i+1}. #{s[0]}: #{s[1]['from']}"
end

puts
puts
puts "The root content that is reblogged"
puts "----------------------------------"

source.to_a.sort_by{|s| -(s[1]['root'] || 0)}.take(1000).each_with_index do |s,i|
  puts "#{i+1}. #{s[0]}: #{s[1]['root']}"
end