require_relative 'spelling_suggestions/solver'

if $0 == __FILE__
  input_path = File.join(File.dirname(__FILE__), '../data/INPUT.txt')
  solver = Solver.new(input_path)
  File.open('003-output.txt', 'w') do |f|
    f.puts(solver.solve)
  end
end
