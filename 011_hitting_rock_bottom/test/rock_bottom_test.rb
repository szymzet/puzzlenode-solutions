require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/rock_bottom'

class RockBottomTest < MiniTest::Unit::TestCase
  def test_cave_equal
    assert_equal(Cave.new("######\n~ ####"), Cave.new("######\n~ ####"))
  end

  def test_cave_not_equal
    refute_equal(Cave.new("###\n#~#\n"), Cave.new("###\n#~ \n"))
  end

  def test_first_step
    cave = Cave.new(<<'CAVE')
################################
~                              #
#         ####                 #
###       ####                ##
###       ####              ####
#######   #######         ######
#######   ###########     ######
################################
CAVE

    expected_cave = Cave.new(<<'CAVE', [1, 1])
################################
~~                             #
#         ####                 #
###       ####                ##
###       ####              ####
#######   #######         ######
#######   ###########     ######
################################
CAVE

    cave.single_flow_step!
    assert_equal(expected_cave, cave)
  end

  def test_second_step
    cave = Cave.new(<<'CAVE', [1, 1])
################################
~~                             #
#         ####                 #
###       ####                ##
###       ####              ####
#######   #######         ######
#######   ###########     ######
################################
CAVE

    expected_cave = Cave.new(<<'CAVE', [2, 1])
################################
~~                             #
#~        ####                 #
###       ####                ##
###       ####              ####
#######   #######         ######
#######   ###########     ######
################################
CAVE

    cave.single_flow_step!
    assert_equal(expected_cave, cave)
  end

  def test_backtracking
    cave = Cave.new(<<'CAVE', [6, 9])
################################
~~                             #
#~~~      ####                 #
###~      ####                ##
###~~~~~  ####              ####
#######~  #######         ######
#######~~~###########     ######
################################
CAVE

    expected_cave = Cave.new(<<'CAVE', [5, 8])
################################
~~                             #
#~~~      ####                 #
###~      ####                ##
###~~~~~  ####              ####
#######~~ #######         ######
#######~~~###########     ######
################################
CAVE

    cave.single_flow_step!
    assert_equal(expected_cave, cave)
  end

  def test_cave_result
    cave = Cave.new(<<'CAVE', [2, 14])
################################
~~~~~~~~~~~~~~~                #
#~~~~~~~~~####~                #
###~~~~~~~####                ##
###~~~~~~~####              ####
#######~~~#######         ######
#######~~~###########     ######
################################
CAVE

    expected_levels = [1, 2, 2, 4, 4, 4, 4, 6, 6, 6, 1, 1, 1, 1, '~',
                       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    assert_equal(expected_levels, cave.current_levels)
  end
end
