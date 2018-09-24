#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'

Bundler.require
require 'fileutils'
require 'json'

$sources = {}

def add(user, type)
    if user && user!=''
        $sources[user] ||= {}
        $sources[user][type.to_s] ||= 0
        $sources[user][type.to_s] += 1
    end
end

processed = 0
old = false
File.open("numbers.dat","w+") do |out|
    Dir.glob("../../scrape/dump/**/*.json") do |fn|
        begin
            processed += 1
            File.open(fn) do |f|            
                d = JSON.parse(f.read)
                d['posts'].each do |post|
                    add(post['reblogged_from_name'], :from)
                    add(post['reblogged_root_name'], :root)
                    own_name = post['blog_name']
                    if post['trail']
                        post['trail'].each_with_index do |trail, idx|
                            trail_blog = trail['blog']['name']
                            if own_name != trail_blog && trail['content']
                                content = trail['content'].gsub(/<\/?[^>]*>/, "").strip
                                if content!=''
                                    add(trail_blog, :trail)
                                    add(trail_blog, :trail_root) if idx == 0

                                    language = CLD.detect_language(content)
                                    if language[:reliable] && language[:name] == "HUNGARIAN"
                                        add(trail_blog, :trail_hun)
                                        add(trail_blog, :trail_root_hun) if idx == 0
                                    end
                                end
                            end
                        end
                    end
                end
            end
        rescue => e
            puts "ERROR"
            puts fn
            puts e.inspect
            puts e.backtrace
        end
        # save progress occasionally
        if processed % 50000 == 0
            puts fn
            STDOUT.flush
            out.puts fn
            out.puts JSON.generate($sources)
            out.flush
        end
    end

    out.puts JSON.generate($sources)
    out.flush

end
