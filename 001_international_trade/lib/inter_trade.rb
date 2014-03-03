require_relative 'inter_trade/solver'

if $0 == __FILE__
  solver = Solver.new(:rates_path => '../data/RATES.xml',
                      :transactions_path => '../data/TRANS.csv')
  File.open('001-output.txt', 'w') do |f|
    f.puts(solver.solve)
  end
end

