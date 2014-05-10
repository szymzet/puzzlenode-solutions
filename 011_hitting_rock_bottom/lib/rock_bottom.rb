class Cave
  WATER = '~'
  AIR = ' '

  attr_reader :cave, :row, :col

  MOVEMENTS = {
    right: [ 0,  1],
    down:  [ 1,  0],
    top:   [-1,  0],
    left:  [ 0, -1]
  }

  def initialize(cave_string, initial_pos = nil)
    @cave = cave_string.split("\n")
    @row, @col = initial_pos || find_flowing_point
  end

  def ==(other)
    @cave == other.cave && row == other.row && col == other.col
  end

  def single_flow_step!
    backtrack if needs_backtracking?
    regular_flow
  end

  def inspect
    "[#{@row}, #{@col}]\n" + @cave.join("\n")
  end

  def current_levels
    @cave[0].size.times.map do |i|
      level = 0
      get_col(i).each do |item|
        if level > 0 && item == AIR
          level = '~'
          break
        elsif item == WATER
          level += 1
        end
      end
      level
    end
  end

  private

  def get_col(i)
    @cave.map { |row| row[i] }
  end

  def needs_backtracking?
    at(:down) != AIR && at(:right) != AIR
  end

  def backtrack
    until at(:right) == AIR
      move!(at(:left) == WATER ? :left : :top)
    end
  end

  def regular_flow
    if at(:down) == AIR
      move!(:down)
    elsif at(:right) == AIR
      move!(:right)
    end
  end

  def at(direction)
    inc_row, inc_col = MOVEMENTS[direction]
    @cave[@row + inc_row][@col + inc_col]
  end

  def move!(direction)
    inc_row, inc_col = MOVEMENTS[direction]
    @col += inc_col
    @row += inc_row
    @cave[@row][@col] = WATER
  end

  def find_flowing_point
    @cave.size.times do |row|
      col = @cave[row].index(WATER)
      return [row, col] unless col.nil?
    end
    nil
  end
end

if $0 == __FILE__
  iterations = gets.chomp.to_i
  gets # skip line
  cave_str = ''
  while line = gets
    cave_str << line
  end
  cave = Cave.new(cave_str)
  iterations.times { cave.single_flow_step! }
  puts cave.current_levels.join(' ')
end
