# frozen_string_literal: true

class Shift < ApplicationRecord
  include ExternalID

  Error = Class.new(StandardError)
  DoubleBookError = Class.new(Error)
  PastStartError = Class.new(Error)

  DURATION = 8.hours

  belongs_to :worker, inverse_of: :shifts

  def duration
    (end_at - start_at).seconds
  end
end
