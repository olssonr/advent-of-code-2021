# frozen_string_literal: true

# A lanternfish which knows how to spawn new fish
class LanternFish
  def initialize(timer = 8)
    @timer = timer
    @age = 8 - timer # TODO: Age is not used, thought it would be fun to track the age instead of using a timer
  end

  # TODO: use constants and/or functions to clarify what all these numbers are
  def act(world)
    if @timer.zero?
      @timer = 6
      spawn_new_fish world
    else
      @timer -= 1
    end

    @age += 1 # Todo see if can switch to age and use % instead of keeping track of both timer and age
  end

  def spawn_new_fish(world)
    world.add_new_fish LanternFish.new
  end

  def to_s
    @timer.to_s
    # "#{6 - ((@age - 2) % 6)}"
  end
end

# Simulation of the world the lantern fish lives in
class World
  attr_reader :fish

  def initialize(starting_fish)
    @fish = starting_fish
    @new_fish = []
    @day = 0
  end

  def tick
    @fish.each do |fish|
      fish.act self
    end

    @day += 1
    @fish.concat @new_fish
    @new_fish = [] # reset new_fish for the next day
  end

  def add_new_fish(fish)
    @new_fish.push fish
  end

  def to_s
    "Day #{@day}: #{@fish.join(', ')}"
  end
end

values = File.readlines('day6_puzzle_input.txt').first.split(',').map(&:to_i)
fish = values.map { |value| LanternFish.new(value) }
world = World.new fish

80.times do
  world.tick
end

puts "Part1: #{world.fish.count}"
