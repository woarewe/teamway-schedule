# frozen_string_literal: true

module REST
  class API
    module Helpers
      module Validation
        def validate!(params, with: nil)
          contract = with.new
          result = contract.call(params)
          error!(result.errors.to_h, 422) if result.failure? # rubocop:disable Rails/DeprecatedActiveModelErrorsMethods

          result.to_h.with_indifferent_access
        end

        def wrapped_error!(errors, status, as:)
          errors = { as => errors }
          error!(errors, status)
        end

        def not_found!(key)
          errors = { key => Array(I18n.t!("rest.validation.errors.not_found")) }
          error!(errors, 404)
        end
      end
    end
  end
end
