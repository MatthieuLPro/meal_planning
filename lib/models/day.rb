
require 'pry'
require_relative '../constantes'

class Day
  def self.create_days_meals
    days = get_sources(DAYS_SOURCE)
    days.values.map do |day_meals|
      meals = []
      MEALS.each do |meal|
        meals << day_meals[meal][DISH_KEYS.first] if day_meals[meal][DISH_KEYS[1]]
      end
      meals
    end.flatten
  end
end