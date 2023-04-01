# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.uuid :external_id, null: false, index: { unique: true }, default: "gen_random_uuid()"
      t.string :name, index: { unique: true }

      t.timestamps
    end
  end
end
