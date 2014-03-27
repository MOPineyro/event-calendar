class ChangeEvent < ActiveRecord::Migration
  def change
    change_column :events, :start, :datetime
    change_column :events, :end, :datetime
  end
end
