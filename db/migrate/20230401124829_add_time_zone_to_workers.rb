class AddTimeZoneToWorkers < ActiveRecord::Migration[7.0]
  def up
    add_column :workers, :time_zone, :string, null: false
  end

  def down
    remove_column :workers, :time_zone
  end
end
