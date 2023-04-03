# frozen_string_literal: true

class Shift
  class Create < BaseOperation
    def call(worker:, start_at:)
      validate_start_at!(start_at)
      attributes = prepare_attributes(worker, start_at)
      handle_exclusion_constraint(DOUBLE_BOOKING_CONSTRAINT) do
        Shift.create!(worker:, **attributes)
      end
    rescue ExclusionError
      double_booking!(attributes.fetch(:local_start_date))
    end

    private

    def validate_start_at!(start_at)
      raise PastStartError, I18n.t!("models.shift.errors.past_start") if start_at.past?
    end

    def prepare_attributes(worker, start_at)
      {
        start_at: worker.local_time(start_at),
        end_at: worker.local_time(start_at + DURATION),
        local_start_date: worker.local_date(start_at),
        local_end_date: worker.local_date(start_at + DURATION)
      }
    end

    def double_booking!(date)
      raise DoubleBookingError, I18n.t!("models.shift.errors.double_booking", date:)
    end
  end
end
