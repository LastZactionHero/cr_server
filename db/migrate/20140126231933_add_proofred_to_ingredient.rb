class AddProofredToIngredient < ActiveRecord::Migration
  def change
    add_column :ingredients, :proofed, :boolean, :default => false
  end
end
