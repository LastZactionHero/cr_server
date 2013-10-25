class DropIngredientsLabels < ActiveRecord::Migration
  def up
    drop_table 'ingredients_labels'
  end

  def down
    create_table 'ingredients_labels', :id => false do |t|
      t.column :label_id, :integer
      t.column :ingredient_id, :integer
    end    
  end
end
