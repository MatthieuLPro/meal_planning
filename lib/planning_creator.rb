# frozen_string_literal: true

require 'yaml'
require 'pry'
require_relative 'misc'
require_relative 'constantes'
require_relative 'models/day'
require_relative 'models/dish'

class PlanningCreator
  def initialize
    @possible_desserts = Dish.create_possible_dishes(DESSERTS_SOURCE)
    @possible_starters = Dish.create_possible_dishes(STARTERS_SOURCE)
    @possible_main_courses = Dish.create_possible_dishes(MAIN_COURSES_SOURCE)
  end

  def dishes_per_day
    meals_per_day = Day.create_days_meals
    current_dish = nil
    current_starter = nil

    meals_per_day.map do |meal|
      main_course = if Dish.dish_remains?(current_dish)
                      current_dish = nil
                      REMAINS
                    else
                      main_course_list_index = Dish.find_priority(@possible_main_courses)
                      current_dish = @possible_main_courses[main_course_list_index].sample
                      @possible_main_courses[main_course_list_index].delete(current_dish)
                      current_dish[DISH_KEYS.first]
                    end

      starter = if Dish.dish_remains?(current_starter) || (@possible_starters[PRIORITIES.first].empty? && @possible_starters[PRIORITIES.second].empty?)
                  current_starter = nil
                  REMAINS
                elsif Dish.starter_available?(current_dish)
                  starter_list_index = Dish.find_priority(@possible_starters)
                  current_starter = @possible_starters[starter_list_index].sample
                  @possible_starters[starter_list_index].delete(current_starter)
                  current_starter[DISH_KEYS.first]
                end

      dessert = if Dish.dessert_available?(current_dish)
                  dessert_list_index = Dish.find_priority(@possible_desserts)
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
end

planning = PlanningCreator.new
pp planning.dishes_per_day
