# frozen_string_literal: true

module REST
  class API
    class Workers < Grape::API
      format "json"

      mount Create
      mount Update
    end
  end
end
