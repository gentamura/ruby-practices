# frozen_string_literal: true

require 'forwardable'

module Ls
  class Files
    extend Forwardable

    def_delegators('@files', 'count', 'each', 'map', 'transpose', 'max_by', 'sort_by!')

    PADDING_SIZE = 2

    def initialize(files)
      @files = files
    end

    def long
      result = []

      padding_hash = {
        nlink: 0,
        user: 0,
        group: 0,
        size: 0
      }

      total_block_count = 0

      @files.each do |file|
        fs = file.stat

        user_name = Etc.getpwuid(fs.uid).name
        group_name = Etc.getgrgid(fs.gid).name

        # Set padding count
        padding_hash[:nlink] = fs.nlink.to_s.size if fs.nlink.to_s.size > padding_hash[:nlink]
        padding_hash[:user] = user_name.size if user_name.size > padding_hash[:user]
        padding_hash[:group] = group_name.size if group_name.size > padding_hash[:group]
        padding_hash[:size] = fs.size.to_s.size if fs.size.to_s.size > padding_hash[:size]

        # Reduce total blocks
        total_block_count += fs.blocks
      end

      # puts "total #{total_block_count}"
      result << "total #{total_block_count}"

      @files.each do |file|
        result << file.stat_detail(**padding_hash)
      end

      result
    end

    def word_padding_size
      @word_padding_size ||= @files.map(&:basename).max_by(&:size).size + PADDING_SIZE
    end
  end
end
