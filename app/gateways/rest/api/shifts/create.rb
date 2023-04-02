# frozen_string_literal: true

module REST
  class API
    class Shifts
      class Create < Base
        class Contract < Dry::Validation::Contract
          json do
            required(:worker_id).filled(:string)
            required(:attributes).hash(Validation::Shift::Attributes.json)
          end
        end

        desc "Schedule a shift for a worker"
        post do
          payload = validate!(params, with: Contract)
          payload => { worker_id: external_id, attributes: { start_at: }}
          worker = ::Worker.find_by(external_id:)
          not_found(:worker_id) if worker.nil?
          start_at = start_at.in_time_zone(worker.time_zone)
          end_at = start_at + ::Shift::DURATION
          shift = Shift.create!(start_at:, end_at:, worker:)
          present shift, with: Serialization::Shift
        end
      end
    end
  end
end
