class AddMatchAndRatingToLabel < ActiveRecord::Migration
  def change
    add_column :labels, :match, :float, :default => 0.0
    add_column :labels, :rating, :integer
  end
end
