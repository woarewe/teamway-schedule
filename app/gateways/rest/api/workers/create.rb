# frozen_string_literal: true

module REST
  class API
    class Workers
      class Create < Base
        class Contract < Dry::Validation::Contract
          json do
            required(:organization_id).filled(:string)
            required(:attributes).hash(Validation::Worker::Attributes.json)
          end
        end

        desc "Create a worker"
        post do
          payload = validate!(params, with: Contract)
          payload => { organization_id: external_id }
          organization = Organization.find_by(external_id:)
          not_found!(:organization_id) if organization.nil?
          authorize! to: :create, with: WorkerPolicy, context: { organization: }

          payload => { attributes: }
          worker = ::Worker.new(organization:, **attributes)

          if worker.save
            present worker, with: Serialization::Worker
          else
            wrapped_error!(worker.errors.as_json, 422, as: :attributes)
          end
        end
      end
    end
  end
end
