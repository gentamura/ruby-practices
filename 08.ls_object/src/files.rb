# frozen_string_literal: true

require 'forwardable'

module Ls
  class Files
    extend Forwardable

    def_delegators('@files', 'count', 'each', 'map', 'transpose', 'max_by', 'sort_by!')

    PADDING_SIZE = 2

    def initialize(file_names)
      @files = file_names.map { |f| Ls::File.new(f) }
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

      result << "total #{total_block_count}"

      @files.each do |file|
        result << file.stat_detail(**padding_hash)
      end

      result
    end

    def normal(window_width)
      cols = window_width / word_padding_size
      rows = (@files.count.to_f / cols).ceil

      files = @files.map(&:basename).each_slice(rows).map do |list|
        unless list.count == rows
          (rows - list.count).times do
            list << ''
          end
        end

        list
      end

      result = []

      files.transpose.map do |file_list|
        padded_file_list = file_list.map { |file| file.ljust(word_padding_size) if file.size != 0  }.compact
        padded_file_list.last.strip!
        result << padded_file_list.join
      end

      result
    end

    private

    def word_padding_size
      @word_padding_size ||= @files.map(&:basename).max_by(&:size).size + PADDING_SIZE
    end
  end
end
