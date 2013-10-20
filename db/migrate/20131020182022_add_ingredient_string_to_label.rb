class AddIngredientStringToLabel < ActiveRecord::Migration
  def change
    add_column :labels, :ingredient_string, :text
  end
end
