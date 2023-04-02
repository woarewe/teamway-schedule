# frozen_string_literal: true

module REST
  module Validation
    module Shift
      class Attributes < Dry::Validation::Contract
        json do
          required(:start_at).filled(:time)
        end
      end
    end
  end
end
