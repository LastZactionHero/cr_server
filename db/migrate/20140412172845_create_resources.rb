class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name
      t.string :description
      t.string :url
      t.string :type
      t.string :meta_dump

      t.timestamps
    end
  end
end
