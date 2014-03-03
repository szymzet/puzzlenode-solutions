require_relative 'transaction_reader'
require_relative 'banking_round'
require_relative 'conversions_reader'
require_relative 'conversion_rates'

class Solver

  include BankingRound

  TRANSACTION_FILTER = /DM1182/
  BASE_CURRENCY = 'USD'

  def initialize(params = {})
    rates_path = params.fetch(:rates_path)
    transactions_path = params.fetch(:transactions_path)

    read_rates(rates_path)
    read_transactions(transactions_path)
  end

  def solve
    unrounded = @transactions.reduce(BigDecimal('0.0')) do |sum, t|
      sum + @rates.convert(t[:currency], BASE_CURRENCY, t[:amount])
    end

    banking_round(unrounded).to_s('F')
  end

  private

  def read_rates(path)
    File.open(path) do |file|
      raw_conversion_data = ConversionsReader.new(file).conversions
      @rates = ConversionRates.new(raw_conversion_data)
    end
  end

  def read_transactions(path)
    File.open(path) do |file|
      @transactions = TransactionReader.new(file, TRANSACTION_FILTER).transactions
    end
  end

end
