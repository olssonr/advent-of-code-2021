# frozen_string_literal: true

# Notes of signals and digit output from a malfunctioning four-digit sevent-segment display
class DisplayEntry
  def initialize(signal_patterns, digit_outputs)
    @signal_patterns = signal_patterns
    @digit_outputs = digit_outputs
  end

  def digits
    @digit_outputs.filter_map(&:digit)
  end

  def to_s
    "#{@signal_patterns.join(' ')} | #{@digit_outputs.join(' ')}"
  end
end

# A digit output from a four-digit seven-segment display
class DigitOutput
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def digit
    case @value.size
    when 2 then 1
    when 4 then 4
    when 3 then 7
    when 7 then 8
    end
  end

  def to_s
    @value.to_s
  end
end

entries = File.readlines('day8_puzzle_input.txt').map do |line|
  signal_patterns, digit_output_values = line.split('|').map(&:split)
  digit_outputs = digit_output_values.map { |value| DigitOutput.new(value) }
  DisplayEntry.new(signal_patterns, digit_outputs)
end

easy_digits_count = entries.sum { |entry| entry.digits.size }

puts "Part1: #{easy_digits_count}"
