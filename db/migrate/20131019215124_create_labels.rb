class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :filename

      t.timestamps
    end
  end
end
