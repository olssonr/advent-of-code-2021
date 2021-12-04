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

    @gamma_rate_binary = most_common_bits
    @oxygen_generator_rating_binary = binary_with_most_common_bits_in_order
    @co2_scrubber_rating_binary = binary_with_least_common_bits_in_order
  end

  def most_common_bits
    bit_array = @binary_matrix.transpose.map { |bits_in_position| most_common_bit(bits_in_position) }
    BinaryNumber.from_array(bit_array)
  end

  # If both bits are equally common 1 is selected
  def most_common_bit(bit_array)
    result = bit_array.tally.max do |a, b|
      if a.last == b.last
        a.first == 1 ? 1 : -1
      else
        a.last <=> b.last
      end
    end
    result.first
  end

  def binary_with_most_common_bits_in_order
    filter_by_most_common_bits_in_order(@binary_matrix, 0)
  end

  def filter_by_most_common_bits_in_order(binary_numbers, position)
    return binary_numbers.first unless binary_numbers.length > 1

    selection_bit = most_common_bit(binary_numbers.transpose[position])
    new_binary_numbers = binary_numbers.select { |binary| binary[position] == selection_bit }

    filter_by_most_common_bits_in_order(new_binary_numbers, position + 1)
  end

  def binary_with_least_common_bits_in_order
    filter_by_least_common_bits_in_order(@binary_matrix, 0)
  end

  def filter_by_least_common_bits_in_order(binary_numbers, position)
    return binary_numbers.first unless binary_numbers.length > 1

    selection_bit = most_common_bit(binary_numbers.transpose[position]) ^ 1
    new_binary_numbers = binary_numbers.select { |binary| binary[position] == selection_bit }

    filter_by_least_common_bits_in_order(new_binary_numbers, position + 1)
  end

  def gamma_rate
    @gamma_rate_binary.to_i
  end

  def epsilon_rate
    @gamma_rate_binary.bitwise_not
  end

  def power_consumption
    gamma_rate * epsilon_rate
  end

  def life_support_rating
    oxygen_generator_rating * co2_scrubber_rating
  end

  def oxygen_generator_rating
    @oxygen_generator_rating_binary.to_i
  end

  def co2_scrubber_rating
    @co2_scrubber_rating_binary.to_i
  end
end

binary_numbers = (File.readlines 'day3_puzzle_input.txt').map { |line| BinaryNumber.from_string(line.chomp) }
report = DiagnosticReport.new(binary_numbers)

puts "Part1 - power consumption: #{report.power_consumption}"
puts "Part2 - life support rating: #{report.life_support_rating}"
