# frozen_string_literal: true

module REST
  module Serialization
    class Shift < Grape::Entity
      include WithTimestamps
      include WithExternalID

      expose :worker, using: Worker
      expose :start_at, format_with: :iso_timestamp
      expose :end_at, format_with: :iso_timestamp
      expose :duration
    end
  end
end
