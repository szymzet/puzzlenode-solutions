require_relative 'longest_common_subseq'
require_relative 'test_case_reader'

class Solver
  def initialize(filename)
    @filename = filename
  end

  def solve
    anwsers = []
    File.open(@filename) do |f|
      TestCaseReader.new(f).each_case do |word, dict|
        anwsers << dict.max_by { |w| lcs_length(word, w) }
      end
    end
    anwsers.join("\n")
  end

  private

  def lcs_length(pat1, pat2)
    LongestCommonSubseq.new(pat1, pat2).length
  end
end

