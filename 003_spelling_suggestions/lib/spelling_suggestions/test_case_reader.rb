class TestCaseReader
  def initialize(input)
    @input = input
    @number_of_cases = next_line.to_i
    # skip empty line
    next_line if @number_of_cases > 0
  end

  def each_case
    @number_of_cases.times do 
      yield(*single_case)
    end
  end

  private

  def single_case
    word = next_line
    dict = []

    until eof?
      line = next_line
      break if line.empty?
      dict << line
    end

    [word, dict]
  end

  def next_line
    @input.readline.chomp
  end

  def eof?
    @input.eof?
  end
end
