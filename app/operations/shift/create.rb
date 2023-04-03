# frozen_string_literal: true

class Shift
  class Create < BaseOperation
    def call(worker:, start_at:)
      validate_start_at!(start_at)
      attributes = prepare_attributes(worker, start_at)
      handle_duplication_error do
        Shift.create!(worker:, **attributes)
      end
    rescue DuplicationError => error
      process_duplication_error(error, attributes)
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

    def process_duplication_error(error, attributes)
      case error.columns
      in [_, :local_start_date]
        raise DoubleBookError, I18n.t!("models.shift.errors.double_book", date: attributes.fetch(:local_start_date))
      in [_, :local_end_date]
        raise DoubleBookError, I18n.t!("models.shift.errors.double_book", date: attributes.fetch(:local_end_date))
      end
    end
  end
end
