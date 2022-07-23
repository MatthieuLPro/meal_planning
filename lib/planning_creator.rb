# frozen_string_literal: true

require 'yaml'
require 'pry'
require_relative 'misc'
require_relative 'constantes'

class PlanningCreator
  def initialize
    @possible_desserts = create_possible_dishes(DESSERTS_SOURCE)
    @possible_starters = create_possible_dishes(STARTERS_SOURCE)
    @possible_main_courses = create_possible_dishes(MAIN_COURSES_SOURCE)
  end

  def dishes_per_day
    meals_per_day = create_days_meals
    current_dish = nil
    current_starter = nil

    meals_per_day.map do |meal|
      main_course = if dish_remains?(current_dish)
                      current_dish = nil
                      REMAINS
                    else
                      main_course_list_index = find_priority(@possible_main_courses)
                      current_dish = @possible_main_courses[main_course_list_index].sample
                      @possible_main_courses[main_course_list_index].delete(current_dish)
                      current_dish[DISH_KEYS.first]
                    end

      starter = if dish_remains?(current_starter) || (@possible_starters[PRIORITIES.first].empty? && @possible_starters[PRIORITIES.second].empty?)
                       current_starter = nil
                       REMAINS
                     elsif starter_available?(current_dish)
                       starter_list_index = find_priority(@possible_starters)
                       current_starter = @possible_starters[starter_list_index].sample
                       @possible_starters[starter_list_index].delete(current_starter)
                       current_starter[DISH_KEYS.first]
                     end

      dessert = if dessert_available?(current_dish)
                  dessert_list_index = find_priority(@possible_desserts)
                  chosen_dessert = @possible_desserts[dessert_list_index].sample
                  @possible_desserts[dessert_list_index].delete(chosen_dessert)
                  chosen_dessert[DISH_KEYS.first]
                end

      {
        meal => {
          DISHES_TYPES_SINGULAR.second => starter,
          DISHES_TYPES_SINGULAR[2] => main_course,
          DISHES_TYPES_SINGULAR.first => dessert
        }
      }
    end
  end

  def find_priority(possible_dishes)
    if prioritized_dishes_empty?(possible_dishes)
      PRIORITIES.second
    else
      PRIORITIES.first
    end
  end

  def prioritized_dishes_empty?(dishes)
    dishes[PRIORITIES.first].empty?
  end

  def create_possible_dishes(dishes_source)
    dishes = get_sources(dishes_source).values
    {
      PRIORITIES.first => dishes.select { |dish| dish[DISH_KEYS[2]] == PRIORITIES.first },
      PRIORITIES.second => dishes.select { |dish| dish[DISH_KEYS[2]] == PRIORITIES.second }
    }
  end

  def create_days_meals
    days = get_sources(DAYS_SOURCE)
    days.values.map do |day_meals|
      meals = []
      MEALS.each do |meal|
        meals << day_meals[meal][DISH_KEYS.first] if day_meals[meal][DISH_KEYS[1]]
      end
      meals
    end.flatten
  end

  def dish_remains?(dish)
    dish && dish[DISH_KEYS[3]]
  end

  def starter_available?(dish)
    dish.nil? || dish[DISH_NEEDED.second]
  end

  def dessert_available?(dish)
    dish && dish[DISH_NEEDED.first]
  end
end

planning = PlanningCreator.new
pp planning.dishes_per_day
