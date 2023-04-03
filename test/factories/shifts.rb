# frozen_string_literal: true

FactoryBot.define do
  factory :shift do
    association :worker, factory: :worker

    transient do
      in_zone_time { (Time.now.in_time_zone(worker.time_zone) + 1.day).change(usec: 0) }
    end

    start_at { in_zone_time }
    end_at { start_at + 8.hours }

    trait :overnight do
      start_at { in_zone_time.change(hour: 22, min: 0) }
    end

    trait :same_day do
      start_at { in_zone_time.beginning_of_day }
    end

    trait :next_day do
      start_at { in_zone_time.next_day }
    end

    trait :in_past do
      start_at { in_zone_time - 7.days }
    end
  end
end
