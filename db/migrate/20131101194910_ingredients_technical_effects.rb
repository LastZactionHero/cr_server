class IngredientsTechnicalEffects < ActiveRecord::Migration
  def up
    create_table 'ingredients_technical_effects', :id => false do |t|
      t.column :ingredient_id, :integer
      t.column :technical_effect_id, :integer
    end
  end

  def down
    drop_table 'ingredients_technical_effects'
  end
end
