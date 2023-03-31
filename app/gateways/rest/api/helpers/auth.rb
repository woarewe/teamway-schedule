# frozen_string_literal: true

module REST
  class API
    module Helpers
      module Auth
        def authenticate!
          @current_user = Services::Authentication.new.call(headers)
        rescue Services::Authentication::Error => error
          error!(error.message, 401)
        end

        def current_user
          @current_user
        end
      end
    end
  end
end
