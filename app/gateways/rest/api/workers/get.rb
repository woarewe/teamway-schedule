# frozen_string_literal: true

module REST
  class API
    class Workers
      class Get < Base
        desc "Get a worker's information"
        get do
          authorize! requested_worker, to: :show, with: WorkerPolicy
          present requested_worker, with: Serialization::Worker
        end
      end
    end
  end
end
