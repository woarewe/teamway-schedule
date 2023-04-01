# frozen_string_literal: true

module REST
  module Serialization
    class Organization < Grape::Entity
      include WithTimestamps
      include WithExternalID

      expose :name
    end
  end
end
