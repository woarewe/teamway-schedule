# frozen_string_literal: true

class Shift < ApplicationRecord
  DOUBLE_BOOKING_CONSTRAINT = "shifts_no_double_booking"

  include ExternalID

  Error = Class.new(StandardError)
  DoubleBookingError = Class.new(Error)
  PastStartError = Class.new(Error)

  DURATION = 8.hours

  belongs_to :worker, inverse_of: :shifts

  delegate :organization, to: :worker

  def duration
    (end_at - start_at).seconds
  end
end
