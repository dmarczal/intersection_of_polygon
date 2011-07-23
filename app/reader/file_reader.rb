#!/usr/bin/env ruby
$: << File.dirname(__FILE__)
require 'benchmark'

module FileReader

  def read
    polygon_a = []
    polygon_b = []
    begin
      count = 0
      size = $stdin.readline.to_i
      (1..size).each do |i|
        line = $stdin.readline
        x, y = line.split.map {|x| x.to_i}
        polygon_a << [x,y] #, count]
        count += 1
      end

      size = $stdin.readline.to_i
      (1..size).each do |i|
        line = $stdin.readline
        x, y = line.split.map {|x| x.to_i}
        polygon_b << [x,y]#, count]
        #count+=1
      end
    rescue EOFError
    end
    {1 => polygon_a, 2 => polygon_b}
  end

end
