# frozen_string_literal: true

require 'yaml'
require 'pry'
require_relative 'misc'
require_relative 'constantes'

class PlanningCreator
  def initialize
    @possible_desserts = create_possible_dishes(DISHES_TYPES[0])
    @possible_first_courses = create_possible_dishes(DISHES_TYPES[1])
    @possible_main_courses = create_possible_dishes(DISHES_TYPES[2])
  end

  def dishes_per_day
    # possible_desserts = create_possible_dishes(DISHES_TYPES[0])
    # possible_first_courses = create_possible_dishes(DISHES_TYPES[1])
    # possible_main_courses = create_possible_dishes(DISHES_TYPES[2])
    meals_per_day = create_days_meals
    current_dish = nil

    meals_per_day.map do |meal|
      main_course = if dish_remains?(current_dish)
                      current_dish = nil
                      'Restes'
                    else
                      # Here
                      main_course_list_index = if prioritized_dishes_empty?(@possible_main_courses)
                                                 PRIORITIES.second
                                               else
                                                 PRIORITIES.first
                                               end
                      current_dish = @possible_main_courses[main_course_list_index].sample
                      @possible_main_courses[main_course_list_index].delete(current_dish)
                      current_dish['name']
                    end

      first_course = if current_dish['first_course_needed']
                       first_course_list_index = if prioritized_dishes_empty?(@possible_first_courses)
                                                   PRIORITIES.second
                                                 else
                                                   PRIORITIES.first
                                                 end
                       chosen_first_course = @possible_first_courses[first_course_list_index].sample
                       @possible_first_courses[first_course_list_index].delete(chosen_first_course)
                       chosen_first_course['name']
                     end

      dessert = if current_dish['dessert_needed']
                  dessert_list_index = if prioritized_dishes_empty?(@possible_desserts)
                                         PRIORITIES.second
                                       else
                                         PRIORITIES.first
                                       end
                  chosen_dessert = @possible_desserts[dessert_list_index].sample
                  @possible_desserts[dessert_list_index].delete(chosen_dessert)
                  chosen_dessert['name']
                end

      {
        meal => {
          'first_course' => first_course,
          'main_course' => main_course,
          'dessert' => dessert
        }
      }
    end
  end

  def create_possible_dishes(type)
    dishes = get_sources(DISHES_SOURCE)[type].values
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
end

def dishes_per_day
  possible_desserts = create_possible_dishes(DISHES_TYPES[0])
  possible_first_courses = create_possible_dishes(DISHES_TYPES[1])
  possible_main_courses = create_possible_dishes(DISHES_TYPES[2])
  meals_per_day = create_days_meals
  current_dish = nil
  current_first_course = nil

  meals_per_day.map do |meal|
    main_course = if dish_remains?(current_dish)
                    current_dish = nil
                    'Restes'
                  else
                    main_course_list_index = if prioritized_dishes_empty?(possible_main_courses)
                                               PRIORITIES.second
                                             else
                                               PRIORITIES.first
                                             end
                    current_dish = possible_main_courses[main_course_list_index].sample
                    possible_main_courses[main_course_list_index].delete(current_dish)
                    current_dish['name']
                  end

    first_course = if dish_remains?(current_first_course) || (possible_first_courses['high'].empty? && possible_first_courses['low'].empty?)
                     current_first_course = nil
                     'Restes'
                   elsif first_course_available?(current_dish)
                     first_course_list_index = if prioritized_dishes_empty?(possible_first_courses)
                                                 PRIORITIES.second
                                               else
                                                 PRIORITIES.first
                                               end
                     current_first_course = possible_first_courses[first_course_list_index].sample
                     possible_first_courses[first_course_list_index].delete(current_first_course)
                     current_first_course['name']
                   end

    dessert = if dessert_available?(current_dish)
                dessert_list_index = if prioritized_dishes_empty?(possible_desserts)
                                       PRIORITIES.second
                                     else
                                       PRIORITIES.first
                                     end
                chosen_dessert = possible_desserts[dessert_list_index].sample
                possible_desserts[dessert_list_index].delete(chosen_dessert)
                chosen_dessert['name']
              end

    {
      meal => {
        'first_course' => first_course,
        'main_course' => main_course,
        'dessert' => dessert
      }
    }
  end
end

def create_possible_dishes(type)
  dishes = get_sources(DISHES_SOURCE)[type].values
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
      meals << day_meals[meal]['name'] if day_meals[meal]['needed']
    end
    meals
  end.flatten
end

def dish_remains?(dish)
  dish && dish['remains']
end

def first_course_available?(dish)
  dish.nil? || dish['first_course_needed']
end

def dessert_available?(dish)
  dish && dish['dessert_needed']
end

def prioritized_dishes_empty?(dishes)
  dishes[PRIORITIES.first].empty?
end

pp dishes_per_day
