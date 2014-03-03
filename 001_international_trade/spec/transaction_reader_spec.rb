require 'rspec'
require 'bigdecimal'
require 'stringio'
require_relative '../lib/inter_trade/transaction_reader'

describe TransactionReader do
  TRANSACTION_DATA = <<EOF
store,sku,amount
Yonkers,DM1210,70.00 USD
Yonkers,DM1182,19.68 AUD
Nashua,DM1182,58.58 AUD
Scranton,DM1210,68.76 USD
Camden,DM1182,54.64 USD
EOF

  subject { TransactionReader.new(StringIO.new(TRANSACTION_DATA), /DM1182/) }

  it 'reads amount and currency filtered by regex' do
    expect(subject.transactions).to eq([{:amount => bd('19.68'), :currency => 'AUD'},
                                        {:amount => bd('58.58'), :currency => 'AUD'},
                                        {:amount => bd('54.64'), :currency => 'USD'}])
  end

  def bd(x)
    BigDecimal.new(x.to_s)
  end
end

