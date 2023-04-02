# frozen_string_literal: true

class CreateShifts < ActiveRecord::Migration[7.0]
  def change
    create_table :shifts do |t|
      t.uuid :external_id, null: false, index: { unique: true }, default: "gen_random_uuid()"
      t.bigint :worker_id, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.date :local_start_date, null: false
      t.date :local_end_date, null: false

      t.timestamps
    end

    add_foreign_key :shifts, :workers

    add_index :shifts, [:worker_id, :local_end_date], unique: true
    add_index :shifts, [:worker_id, :local_start_date], unique: true
  end
end
