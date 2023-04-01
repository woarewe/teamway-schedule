# frozen_string_literal: true

module REST
  class API
    module Helpers
      module Authorization
        def authorize!(object = nil, to:, with: nil)
          policy_class = with || "#{object.class.name}Policy"
          action = "#{to}?"
          policy = policy_class.new(current_user, object)
          error!({}, 404) unless policy.send(action)
        end
      end
    end
  end
end
