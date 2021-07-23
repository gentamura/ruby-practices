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

      result = @long ? @files.long : @files.normal(@window_width)
      result.join("\n")
    end
  end
end
