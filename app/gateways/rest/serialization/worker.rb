# frozen_string_literal: true

module REST
  module Serialization
    class Worker < Grape::Entity
      include WithTimestamps
      include WithExternalID

      expose :first_name
      expose :last_name
      expose :role
    end
  end
end
