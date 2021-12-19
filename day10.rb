# frozen_string_literal: true

OPEN_CHARACTERS = ['(', '[', '{', '<'].freeze

END_TO_OPEN_CHARACTER_MAPPING = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<'
}.freeze

CHARACTER_SCORE_MAPPING = {
  ')' => 3,
  ']' => 57,
  '}' => 1_197,
  '>' => 25_137
}.freeze

def open?(character)
  OPEN_CHARACTERS.include?(character)
end

def open_for_end?(character)
  END_TO_OPEN_CHARACTER_MAPPING[character]
end

def score_for(character)
  CHARACTER_SCORE_MAPPING.fetch(character, 0)
end

def error_score_for(lines)
  lines.map do |line|
    # TODO: Kind of convenient hack that I set default to 0 and I sum on 0 when it's valid
    # perhaps would be good to organize a bit better, or name functions in a way that suits this flow
    failing_character = validate_line(line.chars)
    score_for(failing_character)
  end.sum
end

def validate_line(line)
  validate_character(line, [])
end

def validate_character(line, open_characters)
  return if line.empty?

  character = line.shift

  if open?(character)
    open_characters << character
  else
    latest_character = open_characters.pop
    return character unless latest_character == open_for_end?(character)
  end

  validate_character(line, open_characters)
end

lines = File.readlines('day10_puzzleinput.txt').map(&:chomp)
error_score = error_score_for(lines)

puts "Part1: #{error_score}"
