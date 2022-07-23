
require 'pry'
require_relative '../constantes'


class Dish
  def self.create_possible_dishes(dishes_source)
    dishes = get_sources(dishes_source).values
    {
      PRIORITIES.first => dishes.select { |dish| dish[DISH_KEYS[2]] == PRIORITIES.first },
      PRIORITIES.second => dishes.select { |dish| dish[DISH_KEYS[2]] == PRIORITIES.second }
    }
  end

  def self.find_priority(possible_dishes)
    if prioritized_dishes_empty?(possible_dishes)
      PRIORITIES.second
    else
      PRIORITIES.first
    end
  end

  def self.dish_remains?(dish)
    dish && dish[DISH_KEYS[3]]
  end

  def self.starter_available?(dish)
    dish.nil? || dish[DISH_NEEDED.second]
  end

  def self.dessert_available?(dish)
    dish && dish[DISH_NEEDED.first]
  end

  private

  def self.prioritized_dishes_empty?(dishes)
    dishes[PRIORITIES.first].empty?
  end
end