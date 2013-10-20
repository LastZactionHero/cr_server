class CreateIngredientsLabels < ActiveRecord::Migration
  def up
    create_table 'ingredients_labels', :id => false do |t|
      t.column :label_id, :integer
      t.column :ingredient_id, :integer
    end
  end

  def down
    drop_table 'ingredients_labels'
  end
end
