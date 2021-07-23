#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './src/main'

opt = OptionParser.new

params = { reverse: false, long: false, dot_match: false }

opt.on('-r') { |v| params[:reverse] = v }
opt.on('-l') { |v| params[:long] = v }
opt.on('-a') { |v| params[:dot_match] = v }

opt.parse!(ARGV)

path = ARGV[0] || '.'
pathname = Pathname(path)

puts Ls::Main.new(pathname, **params).exec
