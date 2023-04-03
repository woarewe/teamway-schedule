# frozen_string_literal: true

module REST
  class API
    class Shifts
      class Create < Base
        helpers do
          def handle_operation_errors
            yield
          rescue ::Shift::DoubleBookError, ::Shift::PastStartError => error
            wrapped_error!({ start_at: Array(error.message) }, 422, as: :attributes)
          end
        end

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
          handle_operation_errors do
            shift = ::Shift::Create.new.call(worker:, start_at:)
            present shift, with: Serialization::Shift
          end
        end
      end
    end
  end
end
