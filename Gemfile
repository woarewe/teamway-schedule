# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.3"

gem "dotenv-rails", "~> 2.8", ">= 2.8.1", require: "dotenv/rails-now"

gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "dry-validation", "~> 1.10"
gem "grape", "~> 1.7"
gem "grape-entity", "~> 1.0.0"
gem "grape-swagger", "~> 1.6"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "pundit", "~> 2.3.0"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails", "~> 6.2.0"
  gem "faker", "~> 3.1.1"
  gem "rubocop", "~> 1.48", ">= 1.48.1", require: false
  gem "rubocop-performance", "~> 1.16", require: false
  gem "rubocop-rails", "~> 2.18", require: false
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
