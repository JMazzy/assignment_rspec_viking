require 'spec_helper'
require 'warmup'


describe Warmup do

  let(:warmup) { Warmup.new }

  describe '#gets_shout' do
    it 'returns the input string' do
      allow(warmup).to receive(:gets).and_return("Shout")

      expect(warmup.gets_shout).to eq "SHOUT"
    end
  end

  describe '#triple_size' do
    it 'return the tripled size of a given array' do
      array = double("array", size: 3)

      expect(warmup.triple_size(array)).to eq 9
    end
  end

  describe '#calls_some_methods' do
    it 'it calls upcase on the passed string' do
      string = double("string")

      expect(string).to receive(:upcase!).and_return("string")

      warmup.calls_some_methods(string)
    end

    it 'calls reverse on the passed string' do
      string = "String"

      expect(string).to receive(:reverse!)

      warmup.calls_some_methods(string)
    end

    it 'returns a totally unrelated string' do
      original_string = "hi"

      expect(warmup.calls_some_methods(original_string)).to_not eq original_string
    end
  end
end
