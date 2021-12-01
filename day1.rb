# frozen_string_literal: true

def increments(numbers)
  tuples = numbers.each_cons(2).to_a
  increments = tuples.select { |a, b| b > a }
  increments.count
end

def three_measurements(numbers)
  numbers.each_cons(3).map(&:sum)
end

input = (File.readlines 'day1_puzzle_input.txt').map!(&:to_i)

part1 = increments(input)
puts "Part 1: #{part1}"

part2 = increments(three_measurements(input))
puts "Part 2: #{part2}"
