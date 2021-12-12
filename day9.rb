# frozen_string_literal: true

# Map of lava tube caves use to model how smow flows through the caves
class Map
  attr_reader :low_points

  def initialize(point_matrix)
    @point_lookup_table = Array.new([])
    point_matrix.map.with_index do |points, y|
      @point_lookup_table[y] = points.map.with_index { |height, x| Point.new(x.to_i, y.to_i, height.to_i) }
    end

    @low_points = find_low_points
  end

  def find_low_points
    @point_lookup_table.map do |points|
      points.map do |point|
        adjacent_points = find_adjacent_points_for(point)
        point if adjacent_points.select { |adjacent_point| point.height >= adjacent_point.height }.count.zero?
      end.compact
    end.flatten
  end

  def find_adjacent_points_for(point)
    up = find_point_by(point.x, point.y - 1)
    down = find_point_by(point.x, point.y + 1)
    left = find_point_by(point.x - 1, point.y)
    right = find_point_by(point.x + 1, point.y)
    [up, down, left, right].compact
  end

  def find_point_by(x, y)
    @point_lookup_table.dig(y, x)
  end

  def to_s
    @point_lookup_table.map { |points| points.map(&:height).join('') }.join("\n")
  end
end

# TODO: Inconsistent with height, use z instead?
# Point in a lava tube cave with risk level
class Point
  attr_reader :x, :y, :height

  def initialize(x, y, height)
    @x = x
    @y = y
    @height = height
  end

  def risk_level
    1 + @height
  end

  def to_s
    "(#{@x},#{@y}):#{@height}"
  end
end

point_matrix = File.readlines('day9_puzzle_input.txt').map { |line| line.chomp.split('') }
map = Map.new(point_matrix)

puts "Part1: #{map.low_points.sum(&:risk_level)}"
