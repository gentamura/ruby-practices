# frozen_string_literal: true

require 'optparse'
require 'pathname'
require 'date'
require 'etc'
require 'io/console/size'

require_relative './file'

def long_option(files, result)
  padding_hash = {
    nlink: 0,
    user: 0,
    group: 0,
    size: 0
  }

  total_block_count = 0

  files.each do |file|
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

  files.each do |file|
    result << file.stat_detail(**padding_hash)
  end
end

def exec_ls(pathname, window_width: IO.console_size[1], reverse: false, long: false, all: false)
  flags = all ? File::FNM_DOTMATCH : 0

  file_names = Dir.glob(pathname.join('*'), flags).sort

  max_file_name_size = 0

  files = file_names.map do |f|
    file = Ls::File.new(f)

    max_file_name_size = file.basename.size if file.basename.size > max_file_name_size

    file
  end

  word_padding_size = max_file_name_size + 2

  files = if reverse
            files.sort_by!(&:basename).reverse
          else
            files.sort_by!(&:basename)
          end

  result = []

  if long
    long_option(files, result)
  else
    cols = window_width / word_padding_size
    rows = (files.count.to_f / cols).ceil

    files = files.map(&:basename).each_slice(rows).map do |list|
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
