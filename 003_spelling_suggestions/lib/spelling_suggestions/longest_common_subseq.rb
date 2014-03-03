class LongestCommonSubseq
  def initialize(pat1, pat2)
    @pat1 = pat1
    @pat2 = pat2
  end

  def length
    lcs_table[-1][-1] || 0
  end

  def lcs_table
    return [[]] if @pat1.empty? || @pat2.empty?

    table = init_table
    populate_table(table)
  end

  private

  def init_table
    Array.new(@pat1.size) { Array.new(@pat2.size) { 0 } }
  end

  def populate_table(table)
    @pat1.chars.each_with_index do |c1, i|
      @pat2.chars.each_with_index do |c2, j|
        table[i][j] = choose_length(c1, c2, table, i, j)
      end
    end
    table
  end

  def choose_length(c1, c2, table, i, j)
    if c1 == c2
      up_left(table, i, j) + 1
    else
      [left(table, i, j), up(table, i, j)].max
    end
  end

  def up_left(table, i, j)
    return 0 if i == 0 || j == 0
    table[i - 1][j - 1]
  end

  def left(table, i, j)
    return 0 if j == 0
    table[i][j - 1]
  end

  def up(table, i, j)
    return 0 if i == 0
    table[i - 1][j]
  end
end
