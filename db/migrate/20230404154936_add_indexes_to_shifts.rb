# frozen_string_literal: true

class AddIndexesToShifts < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :shifts, [:start_at, :end_at], algorithm: :concurrently
    add_index :shifts, :worker_id
  end
end
