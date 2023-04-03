# frozen_string_literal: true

module Tests
  module Helpers
    module Shifts
      def over_night_shift_local_start(time_zone)
        far_future_local_time(time_zone).change(hour: 22, min: 0)
      end

      def far_future_local_time(time_zone)
        current_local_time(time_zone) + 1.month
      end

      def far_past_local_time(time_zone)
        current_local_time(time_zone) - 1.month
      end

      def current_local_time(time_zone)
        Time.now.in_time_zone(time_zone).change(usec: 0)
      end

      def local_shift_end(local_shift_start)
        local_shift_start + ::Shift::DURATION
      end

      def assert_no_new_shifts(worker, &)
        assert_no_changes(
          -> { shifts_count(worker) },
          &
        )
      end

      def assert_new_shift(worker, &)
        assert_changes(
          -> { shifts_count(worker) },
          from: shifts_count(worker),
          to: shifts_count(worker) + 1,
          &
        )
      end

      def shifts_count(worker)
        ::Shift.where(worker:).count
      end
    end
  end
end
