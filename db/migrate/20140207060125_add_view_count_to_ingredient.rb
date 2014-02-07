class AddViewCountToIngredient < ActiveRecord::Migration
  def change
    add_column :ingredients, :view_count, :integer, default: 0
  end
end
