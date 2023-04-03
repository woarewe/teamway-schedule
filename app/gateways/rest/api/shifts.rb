# frozen_string_literal: true

module REST
  class API
    class Shifts < Base
      mount Create
      mount Delete
    end
  end
end
