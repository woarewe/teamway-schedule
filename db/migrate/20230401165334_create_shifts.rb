# frozen_string_literal: true

class CreateShifts < ActiveRecord::Migration[7.0]
  def up
    enable_extension "btree_gist"

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

    execute <<~SQL.squish
       ALTER TABLE shifts
       ADD CONSTRAINT #{Shift::DOUBLE_BOOKING_CONSTRAINT}
       EXCLUDE USING GIST (
         worker_id WITH =,
         daterange(local_start_date, local_end_date, '[]') WITH &&
      )
    SQL
  end

  def down
    disable_extension "btree_gist"

    drop_table :shifts
  end
end
