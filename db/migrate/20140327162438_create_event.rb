class CreateEvent < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.column :description, :string
      t.column :location, :string
      t.column :start, :date
      t.column :end, :date

      t.timestamps
    end
  end
end
