#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'

require_relative './src/main'

module Ls
  class Cli
    def initialize(argv)
      opt = OptionParser.new

      params = { reverse: false, long: false, dot_match: false }

      opt.on('-r') { |v| params[:reverse] = v }
      opt.on('-l') { |v| params[:long] = v }
      opt.on('-a') { |v| params[:dot_match] = v }

      opt.parse!(argv)

      path = argv[0] || '.'
      pathname = Pathname(path)
      @main = Ls::Main.new(pathname, **params)
    end

    def exec
      @main.exec
    end
  end
end

puts Ls::Cli.new(ARGV).exec
