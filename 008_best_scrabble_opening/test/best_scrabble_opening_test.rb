require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/best_scrabble_opening'

class BestScrabbleOpeningTest < MiniTest::Unit::TestCase
  def test_tiles_points
    tiles = %W(i4 w5 s2 f7 f7 g6 i4 f7)
    expected_points = { 'i' => 4, 'w' => 5, 's' => 2, 'f' => 7, 'g' => 6 }
    assert_equal(expected_points, points(tiles))
  end

  def test_tiles_letters
    tiles = %W(i4 w5 s2 f7 f7 g6 i4 f7)
    assert_equal(%W(i w s f f g i f), letters(tiles))
  end

  def test_filter_words
    dictionary = %W(lol woot lmao rotfl lool lul xD Lol)
    fitered_words = filter_words(dictionary, %W(l t o L u D x o t w))
    assert_equal(%W(woot xD Lol), fitered_words)
  end

  def test_can_be_built_using
    assert(can_be_built_using?('d', %W(d)))
    assert(can_be_built_using?('rotfl', %W(r 0 O o f x d r t l m)))
    assert(can_be_built_using?('lol', %W(r 0 O f x d r t m l o l)))
    refute(can_be_built_using?('rotfl', %W(r 0 f x d r t l m)))
    refute(can_be_built_using?('rotfl', %W(x d r o t f)))
    refute(can_be_built_using?('lol', %W(l o)))
  end

  def test_calc_score
    points = { 'a' => 1, 'b' => 3, 'c' => 5 }
    board = [[1, 2, 3, 4, 5],
             [1, 1, 1, 100, 3]]
    row, col = 0, 1
    score = calc_score('acba', row, col, board, points)

    assert_equal(34, score)
    assert_equal(6, calc_score('x', 0, 0, [[3]], { 'x' => 2 }))
  end

  def test_best_score_position_horizontal_only
    board = [[1, 2, 3],
             [4, 1, 5],
             [6, 1, 6]]
    points = { 'a' => 1, 'b' => 3, 'c' => 5 }
    assert_equal({ row: 2, col: 0, score: 33 }, best_score_position('cb', board, points))
  end

  def test_print_result
    board = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]

    assert_equal("1 2 3\n4 x d\n7 8 9", print_result('xd', 1, 1, board))
    # args row, col in transposed!
    assert_equal("1 2 x\n4 5 d\n7 8 9", print_result('xd', 2, 0, board, false))
  end

  def test_best_word
    points = { 'a' => 1, 'b' => 3, 'c' => 5 }
    board = [[1, 2, 3, 4, 5],
             [1, 1, 1, 100, 3]]
    row, col = 0, 1
    dictionary = ['aa', 'cc', 'cac', 'acc', 'bbbbb']
    expected = { word: 'acc', row: 1, col: 2, score: 516}
    assert_equal(expected, best_word(dictionary, board, points))
  end
end
