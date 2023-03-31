# frozen_string_literal: true

FactoryBot.define do
  factory :authentication_credentials, class: "Authentication::Credentials" do
    password { Faker::Internet.password }
    username { Faker::Internet.username }
  end
end
