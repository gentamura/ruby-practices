# frozen_string_literal: true

module Ls
  class File
    def initialize(file_name)
      @file_name = file_name
    end

    def basename
      ::File.basename(@file_name)
    end

    def stat
      ::File.stat(@file_name)
    end
  end
end
