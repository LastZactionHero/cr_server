class RemoveLabelIngredientString < ActiveRecord::Migration
  def up
    remove_column :labels, :ingredient_string
  end

  def down
    add_column :labels, :ingredient_string, :text
  end
end
