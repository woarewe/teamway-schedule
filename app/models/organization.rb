# frozen_string_literal: true

class Organization < ApplicationRecord
  include ExternalID

  validates :name, uniqueness: true
end
