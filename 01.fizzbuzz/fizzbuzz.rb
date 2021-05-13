#!/usr/bin/env ruby

(1..20).each do |i|
  three_mult = (i % 3 == 0)
  five_mult = (i % 5 == 0)

  if three_mult && five_mult
    puts 'FizzBuzz'
  elsif three_mult
    puts 'Fizz'
  elsif five_mult
    puts 'Buzz'
  else
    puts i
  end
end
