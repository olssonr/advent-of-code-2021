# frozen_string_literal: true

# A submarine piloted by a crab, can calculate fuel it cost to get to a position
class CrabSubmarine
  def initialize(position)
    @position = position
  end

  def distance_to(position)
    (@position - position).abs
  end

  def fuel_cost_to(position)
    (1..distance_to(position)).sum
  end
end

# A position which a crab can move to. Given a list of crabs it can calculate their cost to move here
class Position
  attr_reader :cost, :distance

  def initialize(value, crab_submarines)
    @value = value
    @distance = calculate_distance(crab_submarines)
    @cost = calculate_cost(crab_submarines)
  end

  def calculate_distance(crab_submarines)
    crab_submarines.sum do |crab_submarine|
      crab_submarine.distance_to(@value)
    end
  end

  def calculate_cost(crab_submarines)
    crab_submarines.sum do |crab_submarine|
      crab_submarine.fuel_cost_to(@value)
    end
  end

  def to_s
    @value.to_s
  end
end

values = File.readlines('day7_puzzle_input.txt').first.split(',').map(&:to_i)
crabs = values.map { |value| CrabSubmarine.new(value) }
positions = values.uniq.map { |value| Position.new(value, crabs) }
position_with_lowest_distance = positions.min_by(&:distance)
position_with_lowest_cost = positions.min_by(&:cost)

puts "Part1: #{position_with_lowest_distance.distance}"
puts "Part2: #{position_with_lowest_cost.cost}"
