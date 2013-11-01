class IngredientsRegulatoryStatuses < ActiveRecord::Migration
  def up
    create_table 'ingredients_regulatory_statuses', :id => false do |t|
      t.column :ingredient_id, :integer
      t.column :regulatory_status_id, :integer
    end
  end

  def down
    drop_table 'ingredients_regulatory_statuses'
  end
end
