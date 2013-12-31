class AddVisibleToIngredient < ActiveRecord::Migration
  def change
    add_column :ingredients, :visible, :boolean, default: false
    add_index :ingredients, :visible
  end
end
