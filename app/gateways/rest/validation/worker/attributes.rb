# frozen_string_literal: true

module REST
  module Validation
    module Worker
      class Attributes < Dry::Validation::Contract
        Role = Types::String.enum(*::Worker::ROLES.to_a)
        TimeZone = Types::String.enum(*TZInfo::Timezone.all.map(&:name))

        json do
          required(:first_name).filled(:string)
          required(:last_name).filled(:string)
          required(:role).filled(Role)
          required(:time_zone).filled(TimeZone)
        end
      end
    end
  end
end
