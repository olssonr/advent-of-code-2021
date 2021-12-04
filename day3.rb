# frozen_string_literal: true

# Representation of a binary number, based on arrays to utilize transpose
class BinaryNumber < Array
  def self.from_array(array)
    new.concat(array)
  end

  def self.from_string(string)
    new(string.chars.map(&:to_i))
  end

  def to_s
    join
  end

  def to_i
    to_s.to_i(2)
  end

  # Since ruby does not provide us with an easy way to use the bitwise not
  # on a binary number we need to implement our own, it works on signed
  # integers and to_s appends - to the number, which is not what we want.
  # This is simple enough use XOR and a bitmask.
  def bitwise_not
    negation_bit_mask = self.class.new(length, 1)
    to_i ^ negation_bit_mask.to_i
  end
end

# Representation of a report from a submarine specialize for finding sleigh keys
class DiagnosticReport
  def initialize(binary_matrix)
    @binary_matrix = binary_matrix

    @gamma_rate_binary_number = most_common_bits_in_matrix
  end

  def most_common_bits_in_matrix
    bit_array = @binary_matrix.transpose.map { |bits_in_position| most_common_bit(bits_in_position) }
    BinaryNumber.from_array(bit_array)
  end

  def most_common_bit(bit_array)
    bit_array.tally.max_by(&:last).first
  end

  def gamma_rate
    @gamma_rate_binary_number.to_i
  end

  def epsilon_rate
    @gamma_rate_binary_number.bitwise_not
  end

  def power_consumption
    gamma_rate * epsilon_rate
  end
end

binary_numbers = (File.readlines 'day3_puzzle_input.txt').map { |line| BinaryNumber.from_string(line.chomp) }
report = DiagnosticReport.new(binary_numbers)

puts "Part1: #{report.power_consumption}"
