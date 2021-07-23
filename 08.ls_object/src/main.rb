# frozen_string_literal: true

require 'optparse'
require 'pathname'
require 'date'
require 'etc'
require 'io/console/size'

require_relative './file'

def ftype(octal_str)
  {
    '10' => 'p', # FIFO
    '20' => 'c', # Character device
    '40' => 'd', # Directory
    '60' => 'b', # Block device
    '100' => '-', # Regular file
    '120' => 'l', # Symbolic link
    '140' => 's' # Socket
  }[octal_str]
end

def permission(permission_str)
  {
    '1' => '--x',
    '2' => '-w-',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }[permission_str]
end

def ftype_and_permission(octal_str)
  permission = octal_str.slice!(-3, 3)

  ftype(octal_str) + permission.split('').map { |d| permission(d) }.join
end

def user_name(uid)
  Etc.getpwuid(uid).name
end

def group_name(gid)
  Etc.getgrgid(gid).name
end

def format_time(time)
  format = time.year == Time.now.year ? '%_m %_d %H:%M' : '%_m %_d  %Y'
  time.strftime(format)
end

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

    # Set padding count
    padding_hash[:nlink] = fs.nlink.to_s.length if fs.nlink.to_s.length > padding_hash[:nlink]
    padding_hash[:user] = user_name(fs.uid).length if user_name(fs.uid).length > padding_hash[:user]
    padding_hash[:group] = group_name(fs.gid).length if group_name(fs.gid).length > padding_hash[:group]
    padding_hash[:size] = fs.size.to_s.length if fs.size.to_s.length > padding_hash[:size]

    # Reduce total blocks
    total_block_count += fs.blocks
  end

  # puts "total #{total_block_count}"
  result << "total #{total_block_count}"

  files.each do |file|
    fs = file.stat

    long_list = "#{ftype_and_permission(fs.mode.to_s(8))}  " # ファイルタイプ アクセス権
    long_list += "#{fs.nlink.to_s.rjust(padding_hash[:nlink])} " # ハードリンク数
    long_list += "#{user_name(fs.uid).rjust(padding_hash[:user])}  " # 所有者名
    long_list += "#{group_name(fs.gid).rjust(padding_hash[:group])}  " # グループ名
    long_list += "#{fs.size.to_s.rjust(padding_hash[:size])} " # バイト数
    long_list += "#{format_time(fs.mtime)} #{file.basename}" # 更新日時（または更新年月日） ファイル名

    # puts result
    result << long_list
  end
end

def exec_ls(pathname, window_width: IO.console_size[1], reverse: false, long: false, all: false)
  flags = all ? File::FNM_DOTMATCH : 0

  file_names = Dir.glob(pathname.join('*'), flags).sort
  file_names = file_names.reverse if reverse

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
