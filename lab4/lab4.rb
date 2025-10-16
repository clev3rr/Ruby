# ---------------- Ingredient ----------------
class Ingredient
  attr_reader :name, :unit, :calories_per_unit

  def initialize(name, unit, calories_per_unit)
    @name = name
    @unit = unit
    @calories_per_unit = calories_per_unit
  end
end

# ---------------- Unit Converter ----------------
class UnitConverter
  def self.to_base(qty, unit)
    case unit
    when :g, :ml, :pcs
      qty
    when :kg
      qty * 1000
    when :l
      qty * 1000
    else
      raise "Unknown unit #{unit}"
    end
  end

  def self.base_for(unit)
    case unit
    when :g, :kg then :g
    when :ml, :l then :ml
    when :pcs then :pcs
    else raise "Unknown unit #{unit}"
    end
  end
end

# ---------------- Recipe ----------------
class Recipe
  attr_reader :name, :steps, :items

  def initialize(name, steps = [], items = [])
    @name = name
    @steps = steps
    @items = items
  end

  def need
    result = {}
    @items.each do |item|
      base_qty = UnitConverter.to_base(item[:qty], item[:unit])
      name = item[:ingredient].name
      base_unit = UnitConverter.base_for(item[:unit])
      result[name] ||= { qty: 0, unit: base_unit }
      result[name][:qty] += base_qty
    end
    result
  end
end

# ---------------- Pantry ----------------
class Pantry
  def initialize
    @storage = {}
  end

  def add(name, qty, unit)
    base_qty = UnitConverter.to_base(qty, unit)
    @storage[name] ||= 0
    @storage[name] += base_qty
  end

  def available_for(name)
    @storage[name] || 0
  end
end

# ---------------- Planner ----------------
class Planner
  def self.plan(recipes, pantry, price_list, calories_list)
    total_need = {}
    total_calories = 0
    total_cost = 0

    recipes.each do |recipe| 
      recipe.need.each do |name, info| 
        total_need[name] ||= { qty: 0, unit: info[:unit] }
        total_need[name][:qty] += info[:qty]
      end
    end

    total_need.each do |name, info|
      have = pantry.available_for(name)
      deficit = [info[:qty] - have, 0].max
      price_per_unit = price_list[name] || 0
      calories_per_unit = calories_list[name] || 0
      total_calories += info[:qty] * calories_per_unit
      total_cost += info[:qty] * price_per_unit

      puts "#{name}: потрібно #{info[:qty]} #{info[:unit]}, є #{have} #{info[:unit]}, дефіцит #{deficit} #{info[:unit]}"
    end

    puts "Total calories: #{total_calories}"
    puts "Total cost: #{total_cost}"
  end
end

# ------------------ DEMO ------------------

PRICE_LIST = {
  'борошно' => 0.02, 'молоко' => 0.015, 'яйце' => 6.0,
  'паста' => 0.03, 'соус' => 0.025, 'сир' => 0.08
}

CALORIES_LIST = {
  'яйце' => 72, 'молоко' => 0.06, 'борошно' => 3.64,
  'паста' => 3.5, 'соус' => 0.2, 'сир' => 4.0
}

flour = Ingredient.new('борошно', :g, 3.64)
milk = Ingredient.new('молоко', :ml, 0.06)
egg = Ingredient.new('яйце', :pcs, 72)
pasta = Ingredient.new('паста', :g, 3.5)
sauce = Ingredient.new('соус', :ml, 0.2)
cheese = Ingredient.new('сир', :g, 4.0)

omelet = Recipe.new('Омлет', [], [
  { ingredient: egg, qty: 3, unit: :pcs },
  { ingredient: milk, qty: 100, unit: :ml },
  { ingredient: flour, qty: 20, unit: :g }
])

pasta_dish = Recipe.new('Паста', [], [
  { ingredient: pasta, qty: 200, unit: :g },
  { ingredient: sauce, qty: 150, unit: :ml },
  { ingredient: cheese, qty: 50, unit: :g }
])

pantry = Pantry.new
pantry.add('борошно', 1, :kg)
pantry.add('молоко', 0.5, :l)
pantry.add('яйце', 6, :pcs)
pantry.add('паста', 300, :g)
pantry.add('сир', 150, :g)

Planner.plan([omelet, pasta_dish], pantry, PRICE_LIST, CALORIES_LIST)
