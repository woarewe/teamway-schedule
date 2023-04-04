# frozen_string_literal: true

module REST
  class API
    class Workers
      class Delete < Base
        desc "Delete a worker"
        delete do
          status 204
          authorize! requested_worker, to: :delete, with: WorkerPolicy
          requested_worker.destroy!
        end
      end
    end
  end
end
