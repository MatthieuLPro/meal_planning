# frozen_string_literal: true

require 'yaml'
require 'pry'
require_relative 'misc'
require_relative 'constantes'

def dishes_per_day
  possible_dishes = create_possible_dishes
  meals_per_day = create_days_meals
  current_dish = nil

  meals_per_day.map do |meal|
    meal_value = if dish_remains?(current_dish)
                   current_dish = nil
                   'Restes'
                 else
                   dish_list_index = if prioritized_dishes_empty?(possible_dishes)
                                       PRIORITIES.second
                                     else
                                       PRIORITIES.first
                                     end
                   current_dish = possible_dishes[dish_list_index].sample
                   possible_dishes[dish_list_index].delete(current_dish)
                   current_dish['name']
                 end
    { meal => meal_value }
  end
end

def create_possible_dishes
  dishes = get_sources(DISHES_SOURCE).values
  {
    PRIORITIES.first => dishes.select { |dish| dish['priority'] == PRIORITIES.first },
    PRIORITIES.second => dishes.select { |dish| dish['priority'] == PRIORITIES.second }
  }
end

def create_days_meals
  days = get_sources(DAYS_SOURCE)
  days.values.map do |day_meals|
    meals = []
    MEALS.each do |meal|
      meals << day_meals[meal]['name'] unless day_meals[meal]['outside']
    end
    meals
  end.flatten
end

def dish_remains?(dish)
  dish && dish['remains']
end

def prioritized_dishes_empty?(dishes)
  dishes[PRIORITIES.first].empty?
end

pp dishes_per_day
