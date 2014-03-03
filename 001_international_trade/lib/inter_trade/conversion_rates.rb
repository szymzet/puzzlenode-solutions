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
    unrounded = calculate_conversion(path, amount)
    banking_round(unrounded)
  end

  private

  NO_PATH = Class.new

  def calculate_conversion(path, amount)
    path.each_cons(2).reduce(BigDecimal.new(amount.to_s)) do |result, pair|
      from, to = *pair
      result * @rates[from][to]
    end
  end

  def add_rate(from, to, rate)
    @rates[from][to] = BigDecimal.new(rate)
  end

  def find_path(from, to)
    visited = Hash[all_currencies.zip([false].cycle)]
    visited[from] = true
    depth_search(to, visited, [from])
  end

  def depth_search(destination, visited, path)
    current_node = path.last
    return path if current_node == destination

    not_visited = @rates[current_node].keys.reject { |node| visited[node] }
    not_visited.each do |node|
      visited[node] = true
      result_path = depth_search(destination, visited, path + [node])
      return result_path unless result_path == NO_PATH
    end

    NO_PATH
  end

  def all_currencies
    (@rates.keys + @rates.values.map(&:keys).flatten).uniq
  end
end
