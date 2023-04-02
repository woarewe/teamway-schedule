# frozen_string_literal: true

class AddTimeZoneToWorkers < ActiveRecord::Migration[7.0]
  def up
    add_column :workers, :time_zone, :string, null: false # rubocop:disable Rails/NotNullColumn
  end

  def down
    remove_column :workers, :time_zone
  end
end
