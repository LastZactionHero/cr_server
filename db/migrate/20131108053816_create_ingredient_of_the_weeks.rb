class CreateIngredientOfTheWeeks < ActiveRecord::Migration
  def change
    create_table :ingredient_of_the_weeks do |t|
      t.integer :ingredient_id
      t.datetime :distributed_at
      t.boolean :distributed, :default => false

      t.timestamps
    end
  end
end
