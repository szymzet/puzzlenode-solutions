module BankingRound

  def banking_round(num)
    return num.round(2) unless (num * 100) % 1.0 == 0.5

    last_digit = (num * 100).to_i % 10
    if last_digit.even?
      return num.floor(2)
    end

    num.ceil(2)
  end

end
