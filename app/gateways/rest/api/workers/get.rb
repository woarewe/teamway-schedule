# frozen_string_literal: true

module REST
  class API
    class Workers
      class Get < Base
        route_param :id do
          desc "Get a worker's information"
          get do
            worker = Worker.find_by(external_id: params.fetch(:id))
            not_found!(:id) if worker.nil?
            authorize! worker, to: :show, with: WorkerPolicy
            present worker, with: Serialization::Worker
          end
        end
      end
    end
  end
end
