require 'rspec'
require 'stringio'
require_relative '../lib/inter_trade/conversions_reader'

describe ConversionsReader do
  CONVERSIONS_XML = '
    <?xml version="1.0"?>
    <rates>
      <rate>
        <from>AUD</from>
        <to>CAD</to>
        <conversion>1.0079</conversion>
      </rate>
      <rate>
        <from>CAD</from>
        <to>USD</to>
        <conversion>1.0090</conversion>
      </rate>
      <rate>
        <from>USD</from>
        <to>CAD</to>
        <conversion>0.9911</conversion>
      </rate>
    </rates>'

  it 'reads conversion rates from IO object' do
    data = ConversionsReader.new(StringIO.new(CONVERSIONS_XML)).conversions
    expect(data).to eq([['AUD', 'CAD', '1.0079'],
                        ['CAD', 'USD', '1.0090'],
                        ['USD', 'CAD', '0.9911']])
  end
end
