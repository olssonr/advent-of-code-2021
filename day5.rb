# frozen_string_literal: true

class Line
  def initialize(start_coordinate, end_coordinate)
    @start_coordinate = start_coordinate
    @end_coordinate = end_coordinate
    raise ArgumentError, 'Only straight lines are allowed' unless valid?
  end

  def valid?
    validate_straight
  end

  def validate_straight
    @start_coordinate.x == @end_coordinate.x || @start_coordinate.y == @end_coordinate.y
  end

  def to_s
    "#{@start_coordinate} -> #{@end_coordinate}"
  end
end

class Coordinate
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    "(#{@x}, #{@y})"
  end
end

def extract_lines(file_lines)
  file_lines.filter_map do |line|
    values = line.split
    start_coordinate = extract_coordinate(values[0])
    end_coordinate = extract_coordinate(values[2])

    # For now, we only consider straight lines
    begin
      Line.new(start_coordinate, end_coordinate)
    rescue ArgumentError
      next
    end
  end
end

def extract_coordinate(string)
  values = string.split(',').map(&:to_i)
  Coordinate.new(values[0], values[1])
end

lines = extract_lines(File.readlines 'test.txt')
puts lines

puts "Part1: #{}"
