require 'rspec'
require 'stringio'
require_relative '../lib/spelling_suggestions/test_case_reader'

describe TestCaseReader do
  INPUT = StringIO.new('2

remimance
remembrance
reminiscence

inndietlly
immediately
incidentally')

  it 'enables iteration over input test cases' do
    expected = [ ['remimance', ['remembrance', 'reminiscence']],
                 ['inndietlly',['immediately', 'incidentally']] ]

    actual = []
    TestCaseReader.new(INPUT).each_case do |word, dict|
      actual << [word, dict]
    end

    expect(actual).to eq expected
  end
end
