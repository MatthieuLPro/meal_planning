# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/models/dish'

RSpec.describe Dish do
  describe '#create_possible_dishes' do
    it 'creates a list of dishes' do
      # TODO
    end
  end

  describe '#find_priority' do
    let(:priority) { Dish.find_priority(possible_dishes) }
    context 'prioritized dishes list is empty' do
      let(:possible_dishes) { { PRIORITIES.first => [] } }
      it 'finds the low prioritized key' do
        expect(priority).to eq(PRIORITIES.second)
      end
    end

    context 'prioritized dishes list is not empty' do
      let(:possible_dishes) { { PRIORITIES.first => ['something'] } }
      it 'finds the high prioritized key' do
        expect(priority).to eq(PRIORITIES.first)
      end
    end
  end

  describe '#dish_remains?' do
    let(:remains) { Dish.dish_remains?(dish) }
    context 'dish does not exist' do
      let(:dish) { nil }
      it 'is falsey' do
        expect(remains).to be_falsey
      end
    end

    context 'dish exists' do
      context 'remains key is true' do
        let(:dish) { { 'remains' => true } }
        it 'is truthy' do
          expect(remains).to be_truthy
        end
      end

      context 'remains key is false' do
        let(:dish) { { 'remains' => false } }
        it 'is falsey' do
          expect(remains).to be_falsey
        end
      end
    end
  end

  describe '#starter_available?' do
    let(:available) { Dish.starter_available?(dish) }
    context 'dish does not exist' do
      let(:dish) { nil }
      it 'is truthy' do
        expect(available).to be_truthy
      end
    end

    context 'dish exists' do
      context 'starter needed key is true' do
        let(:dish) { { 'starter_needed' => true } }
        it 'is truthy' do
          expect(available).to be_truthy
        end
      end

      context 'starter needed key is false' do
        let(:dish) { { 'starter_needed' => false } }
        it 'is falsey' do
          expect(available).to be_falsey
        end
      end
    end
  end

  describe '#dessert_available?' do
    let(:available) { Dish.dessert_available?(dish) }
    context 'dish does not exist' do
      let(:dish) { nil }
      it 'is falsey' do
        expect(available).to be_falsey
      end
    end

    context 'dish exists' do
      context 'dessert needed key is true' do
        let(:dish) { { 'dessert_needed' => true } }
        it 'is truthy' do
          expect(available).to be_truthy
        end
      end

      context 'dessert needed key is false' do
        let(:dish) { { 'dessert_needed' => false } }
        it 'is falsey' do
          expect(available).to be_falsey
        end
      end
    end
  end
end
