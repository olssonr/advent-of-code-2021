# frozen_string_literal: true

class Line
  def initialize(start_coordinate, end_coordinate)
    @start_coordinate = start_coordinate
    @end_coordinate = end_coordinate
  end

  def to_s
    "#{@start_coordinate} -> #{@end_coordinate}"
  end
end

class Coordinate
  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    "(#{@x}, #{@y})"
  end
end

def extract_lines(file_lines)
  file_lines.map do |line|
    values = line.split
    start_coordinate = extract_coordinate(values[0])
    end_coordinate = extract_coordinate(values[2])
    Line.new(start_coordinate, end_coordinate)
  end
end

def extract_coordinate(string)
  values = string.split(',').map(&:to_i)
  Coordinate.new(values[0], values[1])
end

lines = extract_lines(File.readlines 'test.txt')
puts lines

puts "Part1: #{}"
