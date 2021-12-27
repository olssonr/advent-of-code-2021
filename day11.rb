# frozen_string_literal: true

# Representation of a map of dumbo octopuses
class Map
  def initialize(octopus_matrix)
    @octopus_lookup_table = Array.new([])
    octopus_matrix.map.with_index do |octopuses, y|
      @octopus_lookup_table[y] = octopuses.map.with_index do |energy, x|
        Octopus.new(x.to_i, y.to_i, energy.to_i)
      end
    end
  end

  def step
    increment_octopus_energy
    # TODO: Could improve by only fetching flashing octopuses once
    flashable_octopuses.each { |octopus| flash_octopus(octopus) } while flashable_octopuses.count.positive?
    flashing_octopuses.each(&:reset)
  end

  def flashable_octopuses
    @octopus_lookup_table.map do |octopuses|
      octopuses.select(&:flashable?)
    end.flatten
  end

  def flashing_octopuses
    @octopus_lookup_table.map do |octopuses|
      octopuses.select(&:is_flashing)
    end.flatten
  end

  def flash_octopus(octopus)
    return if octopus.is_flashing

    octopus.flashing
    adjacent_octopuses_for(octopus).each(&:increment_energy)
  end

  def increment_octopus_energy
    @octopus_lookup_table.each do |octopuses|
      octopuses.each(&:increment_energy)
    end
  end

  def adjacent_octopuses_for(octopus)
    up = find_octopus_by(octopus.x, octopus.y - 1)
    down = find_octopus_by(octopus.x, octopus.y + 1)
    left = find_octopus_by(octopus.x - 1, octopus.y)
    right = find_octopus_by(octopus.x + 1, octopus.y)
    up_left_diagonal = find_octopus_by(octopus.x - 1, octopus.y - 1)
    up_right_diagonal = find_octopus_by(octopus.x + 1, octopus.y - 1)
    down_left_diagonal = find_octopus_by(octopus.x - 1, octopus.y + 1)
    down_right_diagonal = find_octopus_by(octopus.x + 1, octopus.y + 1)
    [up, down, left, right, up_left_diagonal, up_right_diagonal, down_left_diagonal, down_right_diagonal].compact
  end

  def find_octopus_by(x, y)
    return nil if x.negative? || y.negative?

    @octopus_lookup_table.dig(y, x)
  end

  def num_flashes
    @octopus_lookup_table.sum { |octopuses| octopuses.sum(&:num_flashes) }
  end

  def to_s
    @octopus_lookup_table.map { |octopuses| octopuses.map(&:energy).join('') }.join("\n")
  end
end

# Representation of a dumbo octopus
class Octopus
  attr_reader :x, :y, :energy, :is_flashing, :num_flashes

  def initialize(x, y, energy)
    @x = x
    @y = y
    @energy = energy
    @is_flashing = false
    @num_flashes = 0
  end

  def increment_energy
    @energy += 1
  end

  def reset
    @is_flashing = false
    @energy = 0
  end

  def flashing
    @is_flashing = true
    @num_flashes += 1
  end

  def flashable?
    @energy > 9 && !@is_flashing
  end

  def to_s
    "(#{@x},#{@y}):#{@energy}"
  end
end

matrix = File.readlines('day11_puzzle_input.txt').map { |line| line.chomp.split('') }
map = Map.new(matrix)
100.times { map.step }

puts "Part1: #{map.num_flashes}"
