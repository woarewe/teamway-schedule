# frozen_string_literal: true

FactoryBot.define do
  factory :shift do
    association :worker, factory: :worker

    current_time_zone_time = 1.day.from_now
    start_at { current_time_zone_time.utc.change(usec: 0) }
    end_at { (current_time_zone_time + 8.hours).utc.change(usec: 0) }
  end
end
