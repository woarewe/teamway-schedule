# frozen_string_literal: true

class Worker < ApplicationRecord
  include ExternalID

  self.inheritance_column = "role"

  class << self
    def sti_name
      name.demodulize.underscore
    end

    def find_sti_class(role)
      Worker.const_get(role.camelize)
    end
  end

  ROLES = Set[Manager.sti_name, Regular.sti_name].freeze

  belongs_to :organization, inverse_of: :workers

  has_one(
    :authentication_credentials,
    class_name: "Authentication::Credentials",
    as: :owner,
    dependent: :destroy
  )
  has_many :shifts, dependent: :destroy, inverse_of: :worker

  def local_date(time)
    local_time(time).to_date
  end

  def local_time(time)
    time.in_time_zone(time_zone)
  end

  enum role: ROLES.zip(ROLES).to_h
end
