# frozen_string_literal: true

class CreateWorkers < ActiveRecord::Migration[7.0]
  def change
    create_table :workers do |t|
      t.uuid :external_id, null: false, index: { unique: true }, default: "gen_random_uuid()"
      t.bigint :organization_id, null: false, index: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :role, null: false

      t.timestamps
    end

    add_foreign_key(:workers, :organizations)
  end
end
