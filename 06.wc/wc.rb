#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def directory_or_file(name)
  if Dir.exist?(name)
    puts "wc: #{name}: Not a directory"
    nil
  elsif File.exist?(name)
    name
  else
    puts "wc: #{name}: No such file or directory"
    nil
  end
end

BASE_PADDING = 8

def paddings(line, word, byte)
  line_len = line.to_s.length
  word_len = word.to_s.length
  byte_len = byte.to_s.length

  line_padding = line_len > BASE_PADDING ? line_len + 1 : BASE_PADDING
  word_padding = word_len > BASE_PADDING ? word_len + 1 : BASE_PADDING
  byte_padding = byte_len > BASE_PADDING ? byte_len + 1 : BASE_PADDING

  [line_padding, word_padding, byte_padding]
end

opt = OptionParser.new

params = {}

opt.on('-l') { |v| params[:l] = v }

opt.parse!(ARGV)

is_standard_inputs = ARGV.empty?
TEMP_FILE_NAME = "temp_file_#{Time.now.to_i}.txt"

files = if is_standard_inputs
          lines = readlines

          File.open(TEMP_FILE_NAME, 'w') do |f|
            f.puts(lines)
          end

          [TEMP_FILE_NAME]
        else
          pattern = ARGV.map { |arg| directory_or_file(arg) }.compact.map { |f| "#{f}*" }

          Dir.glob(pattern)
        end

total = {
  line: 0,
  word: 0,
  byte: 0
}

is_total_view = files.length > 1

files.each do |filename|
  line, word, byte = nil

  file_path = File.open(filename) do |f|
    line = f.each_line.count
    word = f.read.split.count
    byte = f.size
    f.to_path
  end

  line_padding, word_padding, byte_padding = paddings(line, word, byte)

  print line.to_s.rjust(line_padding)

  unless params[:l]
    print word.to_s.rjust(word_padding)
    print byte.to_s.rjust(byte_padding)
  end

  puts is_standard_inputs ? '' : " #{file_path}"

  # Prepare for total view
  next unless is_total_view

  total[:line] += line
  total[:word] += word
  total[:byte] += byte
end

if is_total_view
  line, word, byte = paddings(total[:line], total[:word], total[:byte])

  print total[:line].to_s.rjust(line)
  unless params[:l]
    print total[:word].to_s.rjust(word)
    print total[:byte].to_s.rjust(byte)
  end

  puts ' total'
end

File.delete(TEMP_FILE_NAME) if is_standard_inputs
