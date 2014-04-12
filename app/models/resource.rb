class Resource < ActiveRecord::Base
  attr_accessible :description, :meta_dump, :name, :type, :url

  has_and_belongs_to_many :ingredients

  def ingredient_csv
    ingredients.map{|i| i.name}.join(", ")
  end

  def set_ingredients_from_csv!(csv)
    names = csv.split(",").map{|i| i.strip}
    ingredients = names.map{|name| Ingredient.find_by_name(name)}.compact

    self.ingredients = ingredients
    save
  end

end
