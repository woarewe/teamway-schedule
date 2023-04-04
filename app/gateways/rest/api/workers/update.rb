# frozen_string_literal: true

module REST
  class API
    class Workers
      class Update < Base
        class Contract < Dry::Validation::Contract
          json do
            required(:attributes).hash(Validation::Worker::Attributes.json)
          end
        end

        desc "Update a worker"
        put do
          authorize! requested_worker, to: :update, with: WorkerPolicy
          validate!(params, with: Contract) => { attributes: }

          if requested_worker.update(attributes)
            present requested_worker, with: Serialization::Worker
          else
            wrapped_error!(requested_worker.errors.as_json, 422, as: :attributes)
          end
        end
      end
    end
  end
end
