class CreateIngredientResource < ActiveRecord::Migration
  def up
    create_table :ingredients_resources do |t|
      t.integer :ingredient_id
      t.integer :resource_id      
    end
    add_index :ingredients_resources, :ingredient_id
    add_index :ingredients_resources, :resource_id
  end

  def down
    drop_table :ingredients_resources
  end
end
