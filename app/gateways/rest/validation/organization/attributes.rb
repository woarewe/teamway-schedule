# frozen_string_literal: true

module REST
  module Validation
    module Organization
      class Attributes < Dry::Validation::Contract
        json do
          required(:name).filled(:string)
        end
      end
    end
  end
end
