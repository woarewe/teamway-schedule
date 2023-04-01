# frozen_string_literal: true

module REST
  module Serialization
    class Organization < Grape::Entity
      include WithTimestamps

      expose :id do |object, _options|
        object.external_id
      end

      expose :name
    end
  end
end
