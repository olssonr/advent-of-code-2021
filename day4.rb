# frozen_string_literal: true

# System for playing bingo with giant squids
class BingoSubsystem
  attr_reader :boards, :drawn_numbers

  def initialize(numbers, boards)
    @numbers = numbers
    @boards = boards
    @drawn_numbers = [] # TODO: Note used could be removed
  end

  def find_winner
    number = draw_number

    @boards.each do |board|
      board.mark_number number
    end

    winners = @boards.select(&:bingo?)
    return winners.first unless winners.empty?

    find_winner
  end

  def draw_number
    (@drawn_numbers << @numbers.delete_at(0)).last
  end
end

# Representation of a bingo card
class BingoBoard
  def initialize(matrix)
    @matrix = matrix
    @row_counters = Array.new(5, 0)
    @column_counters = Array.new(5, 0)
    @marked_numbers = []
  end

  def mark_number(number)
    @matrix.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        next unless cell == number

        @row_counters[row_index] += 1
        @column_counters[column_index] += 1
        @marked_numbers << number
      end
    end
  end

  def bingo?
    @row_counters.each do |counter|
      return true if counter == 5
    end
    @column_counters.each do |counter|
      return true if counter == 5
    end
    false
  end

  def score
    (sum - @marked_numbers.sum) * @marked_numbers.last
  end

  def sum
    @matrix.sum(&:sum)
  end
end

def extract_boards(lines, acc = [])
  head = lines.delete_at(0)
  return acc if head.nil?

  matrix = []
  5.times do
    row = lines.delete_at(0).split(' ').map(&:to_i)
    matrix << row
  end
  acc << BingoBoard.new(matrix)

  extract_boards(lines, acc)
end

lines = (File.readlines 'day4_puzzle_input.txt')
bingo_numbers = lines[0].split(',').map(&:to_i)
bingo_boards = extract_boards(lines[1..])
bingo_system = BingoSubsystem.new(bingo_numbers, bingo_boards)

puts "Part1: #{bingo_system.find_winner.score}"
