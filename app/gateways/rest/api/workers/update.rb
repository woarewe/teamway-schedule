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

        route_param :id do
          desc "Update a worker"
          put do
            payload = validate!(params, with: Contract)
            payload => { attributes: }
            worker = Worker.find_by(external_id: params.fetch(:id))
            not_found!(:id) if worker.nil?
            authorize! worker, to: :update, with: WorkerPolicy

            if worker.update(attributes)
              present worker, with: Serialization::Worker
            else
              wrapped_error!(worker.errors.as_json, 422, as: :attributes)
            end
          end
        end
      end
    end
  end
end
