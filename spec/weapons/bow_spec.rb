require 'spec_helper'
require 'weapons/bow'

describe Bow do
  let(:bow) { Bow.new }

  describe '#arrows' do
    it 'is readable' do
      expect(bow.respond_to?(:arrows)).to eq true
    end
  end

  describe '#initialize' do
    it 'a new bow starts with 10 arrows by default' do
      expect(bow.arrows).to eq 10
    end

    it 'can be initialzed with an arrow quantity' do
      custom_bow = Bow.new(300)

      expect(custom_bow.arrows).to eq 300
    end
  end

  describe '#use' do
    it 'decreases the arrow count by 1' do
      expect{ bow.use }.to change{ bow.arrows }.by(-1)
    end

    it 'using a bow with 0 arrows throws an error' do

      expect{ bow.use }.to change{ bow.arrows }.by(-1)
    end
  end
end
