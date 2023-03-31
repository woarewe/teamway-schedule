# frozen_string_literal: true

module Authentication
  class Credentials < ApplicationRecord
    belongs_to :owner, polymorphic: true

    has_secure_password
  end
end
