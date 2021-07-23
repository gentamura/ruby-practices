# frozen_string_literal: true

module Ls
  class File
    def initialize(file_name)
      @file_name = file_name
    end

    def basename
      @basename ||= ::File.basename(@file_name)
    end

    def stat
      @stat ||= ::File.stat(@file_name)
    end

    def stat_detail(nlink: 0, user: 0, group: 0, size: 0)
      fs = stat

      row = "#{ftype_and_permission(fs.mode.to_s(8))}  " # ファイルタイプ アクセス権
      row += "#{fs.nlink.to_s.rjust(nlink)} " # ハードリンク数
      row += "#{user_name(fs.uid).rjust(user)}  " # 所有者名
      row += "#{group_name(fs.gid).rjust(group)}  " # グループ名
      row += "#{fs.size.to_s.rjust(size)} " # バイト数
      row += "#{format_time(fs.mtime)} #{basename}" # 更新日時（または更新年月日） ファイル名

      row
    end

    private

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
  end
end
