# frozen_string_literal: true

module REST
  class API
    class Organizations < Grape::API
      format "json"

      mount Create
    end
  end
end
