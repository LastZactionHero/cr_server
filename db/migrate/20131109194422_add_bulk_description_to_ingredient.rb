class AddBulkDescriptionToIngredient < ActiveRecord::Migration
  def change
    add_column :ingredients, :bulk_description, :boolean, :default => true
  end
end
