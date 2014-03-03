require 'csv'
require 'bigdecimal'

class TransactionReader

  attr_reader :transactions

  def initialize(file, filter_regex)
    @transactions = []

    CSV.new(file).each do |row|
      next unless row[1] =~ filter_regex
      amount, currency = row[2].split
      @transactions << {:amount => BigDecimal.new(amount),
                        :currency => currency}
    end
  end
end
