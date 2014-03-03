require 'rspec'
require_relative '../lib/spelling_suggestions/solver'

describe Solver do
  it 'solves sample problem' do
    solver = Solver.new('data/SAMPLE_INPUT.txt')
    expect(solver.solve).to eq "remembrance\nincidentally"
  end
end
