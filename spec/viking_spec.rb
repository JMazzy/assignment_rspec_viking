require 'spec_helper'
require 'viking'

describe Viking do

  let(:viking) { Viking.new }
  let(:viking_with_weapon) {Viking.new("Bob", 100, 10, weapon)}
  let(:weapon) { double("weapon", is_a?: true, use:2) }

  describe "#initialize" do
    it "can be initialized with custom name" do
      named_viking = Viking.new("Bob")
      expect(named_viking.name).to eq("Bob")
    end

    it "can be initialized with a custom health" do
      healthy_viking = Viking.new("Olaf", 120)
      expect(healthy_viking.health).to eq(120)
    end

    it "trying to overwrite health raises an error" do
      expect{viking.health=20}.to raise_error(NoMethodError)
    end

    it "weapon is nil by default" do
      expect(viking.weapon).to eq(nil)
    end
  end

  describe "#pick_up_weapon" do
    it "sets weapon to picked up weapon" do
      viking.pick_up_weapon(weapon)
      expect(viking.weapon).to eq(weapon)
    end

    it "raises error for picking up a non-weapon" do
      fake_weapon = "spear"
      expect{viking.pick_up_weapon(fake_weapon)}.to raise_error(RuntimeError)
    end

    it "replaces existing weapon" do

      new_weapon = double("weapon", is_a?: true)
      viking_with_weapon.pick_up_weapon(new_weapon)
      expect(viking_with_weapon.weapon).to eq(new_weapon)
    end
  end

  describe "#drop_weapon" do
    it "leaves the viking weaponless" do
      viking_with_weapon.drop_weapon
      expect(viking_with_weapon.weapon).to eq(nil)
    end
  end

  describe "#receive_attack" do
    it "reduces the viking's health" do
      expect{viking.receive_attack(10)}.to change{ viking.health }.by(-10)
    end

    it "calls take_damage" do
      expect(viking).to receive(:take_damage).with(10)
      viking.receive_attack(10)
    end
  end

  describe "#attack" do
    it "causes the target's health to drop" do
      target_viking = Viking.new
      expect{viking.attack(target_viking)}.to change{target_viking.health}.by(-2.5)
    end

    it "calls take_damage on the target" do
      target_viking = Viking.new
      expect(target_viking).to receive(:take_damage)
      viking.attack(target_viking)
    end

    it "calls damage_with_fists without weapon" do
      target_viking = Viking.new
      expect(viking).to receive(:damage_with_fists).and_return(2)
      viking.attack(target_viking)
    end

    it "calls fist_multiplier * strength damage" do
      strength = viking.strength
      fists = double("fists", use:0.25)
      expected_damage = strength * fists.use
      viking.instance_variable_set(:@fists, fists)
      target_viking = Viking.new
      expect{viking.attack(target_viking)}.to change{target_viking.health}.by(-expected_damage)
    end

    it "calls damage_with_weapon with weapon" do
      target_viking = Viking.new
      expect(viking_with_weapon).to receive(:damage_with_weapon).and_return(2)
      viking_with_weapon.attack(target_viking)
    end

    it "calls fist_multiplier * strength damage" do
      strength = viking_with_weapon.strength
      expected_damage = strength * weapon.use
      target_viking = Viking.new
      expect{viking_with_weapon.attack(target_viking)}.to change{target_viking.health}.by(-expected_damage)
    end

    it "attacking with bow with no arrows uses fists" do
      bow = double("bow")
      allow(bow).to receive(:use) do
        raise Exception
      end
      viking_with_bow = Viking.new("Bob", 100, 10, bow)
      expect(viking_with_bow).to receive(:damage_with_fists).and_return(1)
      viking_with_bow.attack(viking)
    end
  end

  describe "vikings can never die" do
    it 'NEVER DIES' do 
      massively_powerful_viking = Viking.new("Mazzy", 10000, 10000000)
      expect{ massively_powerful_viking.attack(viking) }.to raise_error RuntimeError
    end
  end
end
