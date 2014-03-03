require 'bigdecimal'
require_relative 'banking_round'

class ConversionRates

  include BankingRound

  def initialize(raw_conversions)
    @rates = Hash.new { |h, k| h[k] = {} }

    raw_conversions.each do |conversion|
      add_rate(*conversion)
    end
  end

  def convert(from_currency, to_currency, amount)
    path = find_path(from_currency, to_currency)

    unrounded = path.each_cons(2).reduce(BigDecimal.new(amount.to_s)) do |result, pair|
      result * @rates[pair[0]][pair[1]]
    end
    banking_round(unrounded)
  end

  private

  NO_PATH = Class.new

  def add_rate(from, to, rate)
    @rates[from][to] = BigDecimal.new(rate)
  end

  def find_path(from, to)
    visited = Hash[all_currencies.zip([false].cycle)]
    visited[from] = true
    depth_search(to, visited, [from])
  end

  def depth_search(to, visited, path)
    return path if path.last == to

    not_visited_children = @rates[path.last].reject { |child, _| visited[child] }
                                            .map { |child, _| child }
    not_visited_children.each do |child|
      visited[child] = true
      result_path = depth_search(to, visited, path + [child])
      return result_path unless result_path == NO_PATH
    end

    NO_PATH
  end

  def all_currencies
    (@rates.keys + @rates.values.map(&:keys).flatten).uniq
  end
end
