# frozen_string_literal: true

def increments(numbers)
  tuples = numbers.each_cons(2).to_a
  increments = tuples.select { |a, b| b > a }
  increments.count
end

input = (File.readlines 'day1_puzzle_input.txt').map!(&:to_i)
puts increments(input)
