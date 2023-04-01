# frozen_string_literal: true

module REST
  module Serialization
    module WithTimestamps
      extend ActiveSupport::Concern

      included do
        format_with(:iso_timestamp, &:iso8601)

        expose :created_at, format_with: :iso_timestamp
        expose :updated_at, format_with: :iso_timestamp
      end
    end
  end
end
