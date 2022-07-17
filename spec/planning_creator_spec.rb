# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/planning_creator'

describe '#dish_remains?' do
  context 'dish does not exist' do
    it 'must be falsey' do
      expect(dish_remains?(nil)).to be_falsey
    end
  end

  context 'dish does not remains' do
    it 'must be falsey' do
      expect(dish_remains?({ 'remains' => false })).to be_falsey
    end
  end

  context 'dish remains' do
    it 'must be truthy' do
      expect(dish_remains?({ 'remains' => true })).to be_truthy
    end
  end
end

describe '#prioritized_dishes_empty?' do
  context 'dishes list is empty' do
    it 'must be truthy' do
      expect(prioritized_dishes_empty?({ 1 => [] })).to be_truthy
    end
  end

  context 'dishes list is not empty' do
    it 'must be falsey' do
      expect(prioritized_dishes_empty?({ 1 => ['something'] })).to be_falsey
    end
  end
end
