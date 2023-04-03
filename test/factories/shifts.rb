# frozen_string_literal: true

FactoryBot.define do
  factory :shift do
    association :worker, factory: :worker

    start_at { Time.now.in_time_zone(worker) }
    end_at { start_at + 8.hours }
  end
end
