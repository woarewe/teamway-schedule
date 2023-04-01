# frozen_string_literal: true

module REST
  class API
    class Workers
      class Delete < Base
        route_param :id do
          desc "Delete a worker"
          delete do
            status 204
            worker = Worker.find_by(external_id: params.fetch(:id))
            not_found!(:id) if worker.nil?
            authorize! worker, to: :delete, with: WorkerPolicy
            worker.destroy!
          end
        end
      end
    end
  end
end
