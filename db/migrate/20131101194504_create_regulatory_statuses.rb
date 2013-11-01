class CreateRegulatoryStatuses < ActiveRecord::Migration
  def change
    create_table :regulatory_statuses do |t|
      t.string :abbreviation
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
