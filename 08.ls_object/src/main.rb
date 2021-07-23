# frozen_string_literal: true

require 'optparse'
require 'pathname'
require 'date'
require 'etc'
require 'io/console/size'

require_relative './file'
require_relative './files'


module Ls
  class Main
    def initialize(pathname, window_width: IO.console_size[1], reverse: false, long: false, dot_match: false)
      dot_match_flag = dot_match ? ::File::FNM_DOTMATCH : 0
      file_names = Dir.glob(pathname.join('*'), dot_match_flag)

      @files = Ls::Files.new(file_names.map { |f| Ls::File.new(f) })

      @window_width = window_width
      @reverse = reverse
      @long = long
    end

    def exec
      if @reverse
        @files.sort_by!(&:basename).reverse!
      else
        @files.sort_by!(&:basename)
      end

      result = []

      if @long
        result = @files.long
      else
        word_padding_size = @files.word_padding_size

        cols = @window_width / word_padding_size
        rows = (@files.count.to_f / cols).ceil

        files = @files.map(&:basename).each_slice(rows).map do |list|
          unless list.count == rows
            (rows - list.count).times do
              list << ''
            end
          end

          list
        end

        files.transpose.each do |file_list|
          padded_file_list = file_list.map { |file| file.ljust(word_padding_size) if file.size != 0  }.compact
          padded_file_list.last.strip!
          result << padded_file_list.join
        end

        result
      end

      result.join("\n")
    end
  end
end
