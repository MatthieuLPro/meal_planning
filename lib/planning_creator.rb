# frozen_string_literal: true

require 'yaml'
require 'pry'
require_relative 'misc'
require_relative 'constantes'
require_relative 'models/day'
require_relative 'models/dish'

class PlanningCreator
  NAME_KEY = DISH_KEYS.first

  def initialize
    @possible_desserts = Dish.create_possible_dishes(DESSERTS_SOURCE)
    @possible_starters = Dish.create_possible_dishes(STARTERS_SOURCE)
    @possible_main_courses = Dish.create_possible_dishes(MAIN_COURSES_SOURCE)

    @current_main_course = nil
    @current_starter = nil
    @current_dessert = nil
  end

  def dishes_per_day
    Day.create_days_meals.map do |meal|
      # We need to find the main course before to find starter and dessert
      # We need to respect the sorting in the hash "meal"
      {
        meal => {
          DISHES_TYPES_SINGULAR[2] => find_main_course,
          DISHES_TYPES_SINGULAR.second => find_starter,
          DISHES_TYPES_SINGULAR.first => find_dessert
        }
      }
    end
  end

  def find_main_course
    if dishes_list_empty?(@possible_main_courses)
      EMPTY_LIST
    elsif Dish.dish_remains?(@current_main_course)
      dish_name = @current_main_course[NAME_KEY]
      @current_main_course = nil
      "#{dish_name} + #{REMAINS}"
    else
      priority_level = Dish.find_priority(@possible_main_courses)
      @current_main_course = @possible_main_courses[priority_level].sample
      @possible_main_courses[priority_level].delete(@current_main_course)
      @current_main_course[NAME_KEY]
    end
  end

  def find_starter
    if dishes_list_empty?(@possible_starters)
      EMPTY_LIST
    elsif Dish.dish_remains?(@current_starter)
      dish_name = @current_starter[NAME_KEY]
      @current_starter = nil
      "#{dish_name} + #{REMAINS}"
    elsif Dish.starter_available?(@current_main_course)
      priority_level = Dish.find_priority(@possible_starters)
      @current_starter = @possible_starters[priority_level].sample
      @possible_starters[priority_level].delete(@current_starter)
      @current_starter[NAME_KEY]
    end
  end

  def find_dessert
    if dishes_list_empty?(@possible_desserts)
      EMPTY_LIST
    elsif Dish.dish_remains?(@current_dessert)
      dish_name = @current_dessert[NAME_KEY]
      @current_dessert = nil
      "#{dish_name} + #{REMAINS}"
    elsif Dish.dessert_available?(@current_main_course)
      priority_level = Dish.find_priority(@possible_desserts)
      @current_dessert = @possible_desserts[priority_level].sample
      if @current_dessert
        @possible_desserts[priority_level].delete(@current_dessert)
        @current_dessert[NAME_KEY]
      end
    end
  end

  def dishes_list_empty?(dishes_list)
    dishes_list[PRIORITIES.first].empty? && dishes_list[PRIORITIES.second].empty?
  end
end

planning = PlanningCreator.new
pp planning.dishes_per_day
