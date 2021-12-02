# frozen_string_literal: true

# Submarine specialize for finding sleigh keys
class Submarine
  attr_reader :horizontal_position, :depth

  def initialize
    @horizontal_position = 0
    @depth = 0
  end

  def execute(command)
    case command.operation
    when :forward
      @horizontal_position += command.units
    when :down
      @depth += command.units
    when :up
      @depth -= command.units
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

input = File.readlines 'day2_puzzle_input.txt'

submarine = Submarine.new
commands(input).each do |command|
  submarine.execute command
end

part1 = submarine.horizontal_position * submarine.depth
puts "Part 1: #{part1}"
