require 'json'

def points(tiles)
  tiles.map { |tile| [tile[0], tile[1..-1].to_i] }.to_h
end

def letters(tiles)
  tiles.map { |tile| tile[0] }
end

def filter_words(dictionary, letters)
  dictionary.find_all { |word| can_be_built_using?(word, letters) }
end

def can_be_built_using?(needle, haystack)
  haystack_letter = haystack.sort.each
  needle.split('').sort.each do |letter|
    while haystack_letter.next != letter
    end
  end
  true
rescue StopIteration
  return false
end

def calc_score(word, row, col, board, points)
  subboard = board[row][col, word.size]
  word_points = word.split('').map { |letter| points[letter] }
  subboard.zip(word_points).reduce(0) { |acc, pair| acc + pair[0] * pair[1] }
end

def best_score_position(word, board, points)
  max_col = board[0].size - word.size
  best = {row: -1, col: -1, score: -1}
  board.size.times do |row|
    (0..max_col).each do |col|
      score = calc_score(word, row, col, board, points)
      if score > best[:score]
        best[:row] = row
        best[:col] = col
        best[:score] = score
      end
    end
  end
  best
end

def best_word(dictionary, board, points)
  dictionary.each_with_object({word: '', row: -1, col: -1, score: -1}) do |word, best|
    result = best_score_position(word, board, points)
    if result[:score] > best[:score]
      best[:word] = word
      best.merge!(result)
    end
  end
end

def print_result(word, row, col, board, horizontal=true)
  board = board.transpose unless horizontal

  new_row = board[row][0...col] + word.split('') + board[row][(col + word.size)..-1]
  new_board = board[0...row] + [new_row] + board[(row + 1)..-1]

  new_board = new_board.transpose unless horizontal

  new_board.map { |row| row.join(" ") }.join("\n")
end

if $0 == __FILE__
  contents = File.read(ARGV[1] || 'INPUT.json')
  data = JSON.parse(contents)
  points = points(data['tiles'])
  letters = letters(data['tiles'])
  dictionary = filter_words(data['dictionary'], letters)
  board = data['board'].map { |row| row.split(" ").map(&:to_i) }

  best_horizontal = best_word(dictionary, board, points)
  best_vertical = best_word(dictionary, board.transpose, points)

  best = best_horizontal
  is_horizontal = true
  if best_vertical[:score] > best_horizontal[:score]
    is_horizontal = false
    best = best_vertical
  end

  puts print_result(best[:word], best[:row], best[:col], board, is_horizontal)
end
