#!/usr/bin/env ruby
$: << File.dirname(__FILE__)
require 'benchmark'

module FileReader

  def read
    polygon_a = []
    polygon_b = []
    begin
      size = $stdin.readline.to_f
      (1..size).each do |i|
        line = $stdin.readline
        x, y = line.split.map {|x| x.to_f}
        polygon_a << [x,y]
      end

      size = $stdin.readline.to_f
      (1..size).each do |i|
        line = $stdin.readline
        x, y = line.split.map {|x| x.to_f}
        polygon_b << [x,y]
      end
    rescue EOFError
    end
    {1 => polygon_a, 2 => polygon_b}
  end

end
