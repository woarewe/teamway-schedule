# frozen_string_literal: true

module REST
  module Validation
    module Shift
      class Filter < Dry::Validation::Contract
        MAX_PERIOD = 31

        params do
          required(:from).filled(:date_time)
          required(:to).filled(:date_time)
        end

        rule(:from, :to) do
          next if (values[:to] - values[:from]) <= MAX_PERIOD

          key(:period).failure(I18n.t!("rest.api.organizations.shifts.errors.long_period", period: MAX_PERIOD))
        end
      end
    end
  end
end
