# frozen_string_literal: true

namespace :admin do
  task create: :environment do
    username = ENV.fetch("ADMIN_USERNAME")
    password = ENV.fetch("ADMIN_PASSWORD")

    Authentication::Credentials.create!(username:, password:, owner: Admin.create!)
    token = Base64.encode64("#{username}:#{password}")
    payload = "Bearer #{token}"
    puts "Your payload for #{REST::Services::Authentication::HEADER} header: #{payload}"
  end
end
