# frozen_string_literal: true

module REST
  module Serialization
    module WithExternalID
      extend ActiveSupport::Concern

      included do
        expose :id do |object, _options|
          object.external_id
        end
      end
    end
  end
end
