# frozen_string_literal: true

class CreateAuthCredentials < ActiveRecord::Migration[7.0]
  def change
    create_table :authentication_credentials do |t|
      t.string :username, null: false, index: { unique: true }
      t.text :password_digest, null: false

      t.string :owner_type, null: false
      t.bigint :owner_id, null: false
      t.timestamps
    end

    add_index(:authentication_credentials, %i[owner_id owner_type], unique: true)
  end
end
