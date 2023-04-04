# frozen_string_literal: true

module REST
  class API
    module Helpers
      module Authorization
        def authorize!(object = nil, to:, with: nil, context: {})
          action = "#{to}?"
          policy = with.new(current_user, object, **context)
          error!({}, 404) unless policy.send(action)
        end
      end
    end
  end
end
