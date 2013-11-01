class CreateTechnicalEffects < ActiveRecord::Migration
  def change
    create_table :technical_effects do |t|
      t.string :abbreviation
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
