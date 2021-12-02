# frozen_string_literal: true

# Submarine specialized for finding sleigh keys
class Submarine
  attr_reader :horizontal_position, :depth

  def initialize
    @horizontal_position = 0
    @depth = 0
    @aim = 0
  end

  def execute(command)
    case command.operation
    when :forward
      @horizontal_position += command.units
      @depth += command.units * @aim
    when :down
      @depth += command.units
    when :up
      @depth -= command.units
    when :aim
      @aim += command.units
    else
      raise ArgumentError("Unknown operation: #{command.operation}")
    end
  end
end

# Command a submarine can execute
class Command
  attr_reader :operation, :units

  def initialize(operation, units)
    @operation = operation
    @units = units
  end
end

def commands(lines)
  lines.map do |line|
    operation, units = line.split(' ')
    Command.new(operation.to_sym, units.to_i)
  end
end

def commands_with_aim(lines)
  lines.map do |line|
    operation, units = line.split(' ')
    units = units.to_i

    case operation
    when 'up'
      operation = :aim
      units = -units
    when 'down'
      operation = :aim
    end

    Command.new(operation.to_sym, units)
  end
end

input = File.readlines 'day2_puzzle_input.txt'

submarine = Submarine.new
commands(input).each do |command|
  submarine.execute command
end

part1 = submarine.horizontal_position * submarine.depth
puts "Part 1: #{part1}"

submarine = Submarine.new
commands_with_aim(input).each do |command|
  submarine.execute command
end

part2 = submarine.horizontal_position * submarine.depth
puts "Part 2: #{part2}"
