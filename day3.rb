# frozen_string_literal: true

lines = (File.readlines 'day3_puzzle_input.txt').map(&:chomp)

one_counter = Array.new(lines.first.length, 0)
lines.map do |line|
  line.chars.each_with_index { |char, index| one_counter[index] += char.to_i }
end

# TODO: Learn how to work with binaries in ruby, this is silly
gamma_rate_binary_string = one_counter.map { |num| num > lines.count / 2 ? "1" : "0" }.join

gamma_rate = gamma_rate_binary_string.to_i(2)
epsilon_rate = gamma_rate ^ ("1" * lines.first.length).to_i(2)
power_consumption = gamma_rate * epsilon_rate

puts "Part 1: #{power_consumption}"
