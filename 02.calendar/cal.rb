#!/usr/bin/env ruby

require 'optparse'
require 'date'

opt = OptionParser.new

params = {}

opt.on('-y YEAR') {|v| params[:year] = v }
opt.on('-m MONTH') {|v| params[:month] = v }

opt.parse!(ARGV)

today = Date.today

year = params[:year] ? params[:year].to_i : today.year
month = params[:month] ? params[:month].to_i : today.month
last_mday = Date.new(year, month, -1).mday
SAT = 6


puts "      #{month}月 #{year}"
puts "日 月 火 水 木 金 土"

(1..last_mday).each do |v|
  date = Date.new(year, month, v)

  mday = if v.to_s.length == 2
    "#{v}"
  else
    " #{v}"
  end

  formatted_mday = if (date.cwday == SAT || last_mday == v)
    mday << "\n"
  else
    mday << " "
  end

  if v === 1
    first_week_padding_count = 7 - (7 - date.cwday)

    if first_week_padding_count < 7
      first_week_padding = first_week_padding_count.times.map{|n| " " * 3 }.join('')
      formatted_mday = first_week_padding << formatted_mday
    end
  end

  print formatted_mday
end
