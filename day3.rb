# frozen_string_literal: true

# Since ruby does not provide us with an easy way to use the bitwise not
# on a binary number we need to implement our own, it works on signed
# integers and to_s appends - to the number, which is not what we want.
# This is simple enough use XOR and a bitmask.
def bitwise_not(binary_string)
  length = binary_string.length
  negation_bit_mask = ("1" * length)
  binary_string.to_i(2) ^ negation_bit_mask.to_i(2)
end

binary_strings = (File.readlines 'day3_puzzle_input.txt').map(&:chomp)
binary_length = binary_strings.first.length

one_counter = Array.new(binary_length, 0)
binary_strings.map do |binary_string|
  binary_string.chars.each_with_index { |char, index| one_counter[index] += char.to_i }
end

# TODO: Learn how to work with binaries in ruby, this is silly
gamma_rate_binary_string = one_counter.map { |num| num > binary_strings.count / 2 ? "1" : "0" }.join

gamma_rate = gamma_rate_binary_string.to_i(2)
epsilon_rate = bitwise_not(gamma_rate_binary_string)
power_consumption = gamma_rate * epsilon_rate

puts "Part 1: #{power_consumption}"
