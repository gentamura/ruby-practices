#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def directory_or_file(name)
  if Dir.exist?(name)
    if name.end_with?('/')
      name
    else
      "#{name}/"
    end
  elsif name.end_with?('/')
    puts "wc: #{name}: Not a directory"
    nil
  elsif File.exist?(name)
    name
  else
    puts "wc: #{name}: No such file or directory"
    nil
  end
end

opt = OptionParser.new

params = {}

opt.on('-l') { |v| params[:l] = v }

opt.parse!(ARGV)

pattern = if ARGV.empty?
            '*'
            # TODO: basic input in wc?
          else
            ARGV
              .map { |arg| directory_or_file(arg) }
              .compact
              .map { |file| "#{file}*" }
          end

files = Dir.glob(pattern).sort

BASE_PADDING = 8

files.each do |f|
  file = File.new(f)
  line = file.each_line.count # lines

  file = File.new(f)
  word = file.each_line.reduce { |result, s| result << s }.split.count # words

  byte = file.size # byte

  line_len = line.to_s.length
  word_len = word.to_s.length
  byte_len = byte.to_s.length

  line_padding = line_len > BASE_PADDING ? line_len + 1 : BASE_PADDING
  word_padding = word_len > BASE_PADDING ? word_len + 1 : BASE_PADDING
  byte_padding = byte_len > BASE_PADDING ? byte_len + 1 : BASE_PADDING

  if params[:l]
    print line.to_s.rjust(line_padding)
  else
    print line.to_s.rjust(line_padding)
    print word.to_s.rjust(word_padding)
    print byte.to_s.rjust(byte_padding)
  end

  puts " #{file.to_path}"
end
