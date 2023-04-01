# frozen_string_literal: true

FactoryBot.define do
  factory :worker do
    association :organization, factory: :organization

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    role { Worker::ROLES.to_a.sample }

    trait :manager do
      role { Worker::Manager.sti_name }
    end

    trait :regular do
      role { Worker::Regular.sti_name }
    end
  end
end
