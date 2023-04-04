# frozen_string_literal: true

class Shift < ApplicationRecord
  DOUBLE_BOOKING_CONSTRAINT = "shifts_no_double_booking"

  include ExternalID

  Error = Class.new(StandardError)
  DoubleBookingError = Class.new(Error)
  PastStartError = Class.new(Error)

  DURATION = 8.hours

  belongs_to :worker, inverse_of: :shifts

  scope :for_organization, ->(organization) { joins(:worker).where(workers: { organization: }) }
  scope :for_worker, ->(worker) { where(worker:) }
  scope :between, ->(from, to) { where(start_at: from.utc..to.utc) }
  scope :chronologically, -> { order(start_at: :asc) }
  scope :serial, -> { order(created_at: :asc) }

  delegate :organization, to: :worker

  def duration
    (end_at - start_at).seconds
  end
end
