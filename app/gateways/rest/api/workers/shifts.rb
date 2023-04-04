# frozen_string_literal: true

module REST
  class API
    class Workers
      class Shifts < Base
        helpers do
          def select_shifts(filters)
            filters => { from:, to: }
            ::Shift
              .includes(:worker)
              .for_worker(requested_worker)
              .between(from, to)
              .chronologically
              .serial
          end
        end

        desc "Get worker's shifts"
        get do
          authorize! requested_worker, to: :view_shifts, with: WorkerPolicy
          filters = validate!(params, with: Validation::Shift::Filter)
          present select_shifts(filters), with: Serialization::Shift
        end
      end
    end
  end
end
