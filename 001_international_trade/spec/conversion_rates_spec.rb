require 'rspec'
require 'bigdecimal'
require 'stringio'
require_relative '../lib/inter_trade/conversion_rates'

describe ConversionRates do
  def bd(x)
    BigDecimal.new(x.to_s)
  end

  CONVERSIONS = [['AAA', 'BBB', '2'],
                 ['BBB', 'CCC', '3'],
                 ['CCC', 'AAA', '0.3'], # add a cycle in the graph
                 ['DDD', 'CCC', '0.2'],
                 ['DDD', 'EEE', '7']]

  subject { ConversionRates.new(CONVERSIONS) }

  it 'knows when no conversion needed' do
    expect(subject.convert('CCC', 'CCC', bd('332.43'))).to eq(bd('332.43'))
    expect(subject.convert('EEE', 'EEE', bd('99.1'))).to eq(bd('99.1'))
  end

  it 'does bi-directional conversions' do
    expect(subject.convert('CCC', 'DDD', bd('1.0'))).to eq(bd('5'))
    expect(subject.convert('DDD', 'CCC', bd('20.0'))).to eq(bd('4'))
  end

  it 'finds correct conversion path' do
    expect(subject.convert('AAA', 'EEE', 10.0)).to eq(bd('2100'))
  end

  context 'rounding' do
    it 'rounds normally when no rounding tie' do
      convert_down = ConversionRates.new([['ABC', 'XYZ', '1.1234']])
      convert_up = ConversionRates.new([['ABC', 'XYZ', '1.1264']])

      expect(convert_down.convert('ABC', 'XYZ', bd('1.0'))).to eq(bd('1.12'))
      expect(convert_up.convert('ABC', 'XYZ', bd('1.0'))).to eq(bd('1.13'))
    end

    it 'rounds to nearest even when rounding tie' do
      convert_down = ConversionRates.new([['ABC', 'XYZ', '1.125']])
      convert_up = ConversionRates.new([['ABC', 'XYZ', '1.135']])

      expect(convert_down.convert('ABC', 'XYZ', bd('1.0'))).to eq(bd('1.12'))
      expect(convert_up.convert('ABC', 'XYZ', bd('1.0'))).to eq(bd('1.14'))
    end

    it 'does not round intermediate conversions' do
      convert = ConversionRates.new([['ABC', 'XYZ', '0.0001'],
                                     ['XYZ', 'LOL', '10000']])
      expect(convert.convert('ABC', 'LOL', bd('1.01'))).to eq(bd('1.01'))
    end
  end
end

