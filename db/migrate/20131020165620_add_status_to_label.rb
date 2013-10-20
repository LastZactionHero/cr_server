class AddStatusToLabel < ActiveRecord::Migration
  def change
    add_column :labels, :status, :string
  end
end
