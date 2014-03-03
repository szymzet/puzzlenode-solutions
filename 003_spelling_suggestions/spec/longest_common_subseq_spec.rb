require_relative '../lib/spelling_suggestions/longest_common_subseq'
require 'rspec'

describe LongestCommonSubseq do

  def lcs(pat1, pat2) 
    LongestCommonSubseq.new(pat1, pat2)
  end

  describe "#length" do
    it 'returns 0 when no common subsequence' do
      expect(lcs('asdf', 'xyz').length).to eq 0
      expect(lcs('', 'x').length).to eq 0
      expect(lcs('x', '').length).to eq 0
    end

    it 'returns length when patterns are equal' do
      expect(lcs('xyxuz', 'xyxuz').length).to eq 5
    end

    it 'returns length of longest common subsequence' do
      expect(lcs('agcat', 'gac').length).to eq 2
      expect(lcs('mzjawxu', 'xmjyauz').length).to eq 4
    end

  end

  describe "#lcs_table" do
    it 'is 2D when empty' do
      table1 = lcs('', '').lcs_table
      expect(table1.size).to eq 1
      expect(table1.first.size).to eq 0
    end

    it 'has dimensions size1 by size2' do
      table = lcs('12345', '1234').lcs_table
      expect(table.size).to eq 5
      expect(table.first.size).to eq 4
    end

    it 'is filled with zeros when no match' do
      expect(lcs('xyz', 'abcd').lcs_table.flatten.count(0)).to eq 3*4
    end

    it 'represents dynamic programming problem' do
      expect(lcs('gac', 'agcat').lcs_table).to eq([[0, 1, 1, 1, 1],
                                                   [1, 1, 1, 2, 2],
                                                   [1, 1, 2, 2, 2]])
    end
  end
end
