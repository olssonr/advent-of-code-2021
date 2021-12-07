# frozen_string_literal: true

# Used for tracking all lines to detect overlaps
class Map
  def initialize
    @map_counters = Hash.new(0)
    @max_y = 99
    @max_x = 99
  end

  def count_line(line)
    line.covered_coordinates.each do |coordinate|
      @map_counters[coordinate] += 1
    end
  end

  def coordinates_covered_at_least(times)
    @map_counters.filter_map { |_coordinate, times_covered| times_covered >= times }
  end

  # Only returns a 9x9 grid, anything more is hard to read... puzzle input looks like 999x999...
  def to_s
    (0..@max_y).map do |y|
      (0..@max_x).map do |x|
        @map_counters[Coordinate.new(x, y)].to_s
      end.join
    end.join("\n")
  end
end

# A line of hydrothermal vents
class Line
  def initialize(start_coordinate, end_coordinate)
    @start_coordinate = start_coordinate
    @end_coordinate = end_coordinate
    raise ArgumentError, 'Only straight lines are allowed' unless valid?
  end

  def covered_coordinates
    if vertical_line?
      range_begin = [@start_coordinate.y, @end_coordinate.y].min
      range_end = [@start_coordinate.y, @end_coordinate.y].max
      (range_begin..range_end).map { |y| Coordinate.new(@start_coordinate.x, y) }
    else
      range_begin = [@start_coordinate.x, @end_coordinate.x].min
      range_end = [@start_coordinate.x, @end_coordinate.x].max
      (range_begin..range_end).map { |x| Coordinate.new(x, @start_coordinate.y) }
    end
  end

  def valid?
    validate_straight
  end

  def validate_straight
    vertical_line? || horizontal_line?
  end

  def vertical_line?
    @start_coordinate.x == @end_coordinate.x
  end

  def horizontal_line?
    @start_coordinate.y == @end_coordinate.y
  end

  def to_s
    "#{@start_coordinate} -> #{@end_coordinate}"
  end
end

# A point on the ocean floor where a hydrothermal vent is located
class Coordinate
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    "(#{@x}, #{@y})"
  end

  # Cool so by defining these three methods the key is the same for coordinates with same x and y
  # Look into this a bit more if this is the best way to do it etc.
  def ==(other)
    @x == other.x && @y == other.y
  end

  alias eql? ==

  def hash
    @x.hash ^ @y.hash
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

lines = extract_lines(File.readlines('day5_puzzle_input.txt'))
puts lines
map = Map.new
lines.each { |line| map.count_line(line) }
puts map

puts "Part1: #{map.coordinates_covered_at_least(2)&.count}"
