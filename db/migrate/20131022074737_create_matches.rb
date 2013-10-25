class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :ingredient_id
      t.integer :label_id
      t.float :similarity, :default => 0.0

      t.timestamps
    end
    
    add_index :matches, :ingredient_id
    add_index :matches, :label_id
  end
end
