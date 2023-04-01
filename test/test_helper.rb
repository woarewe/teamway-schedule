# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module Tests; end
require_relative "helpers"

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    parallelize(workers: :number_of_processors)

    fixtures :all
  end
end
