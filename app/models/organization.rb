# frozen_string_literal: true

class Organization < ApplicationRecord
  include ExternalID

  validates :name, uniqueness: true

  has_many :workers, dependent: :destroy, inverse_of: :organization
  has_many :managers, class_name: "Worker::Manager", dependent: :destroy, inverse_of: :organization

  def manager?(worker)
    manager_ids.include?(worker.id)
  end
end
