# frozen_string_literal: true

module Tests
  module Helpers
    module API
      def response_body
        JSON.parse(@response.body).with_indifferent_access
      end
    end
  end
end
