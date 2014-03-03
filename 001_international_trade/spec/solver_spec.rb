require 'rspec'
require_relative '../lib/inter_trade/solver.rb'

describe Solver do
  it 'solves sample problem' do
    solver = Solver.new(:rates_path => 'data/SAMPLE_RATES.xml',
                        :transactions_path => 'data/SAMPLE_TRANS.csv')
    expect(solver.solve).to eq '134.22'
  end
end
