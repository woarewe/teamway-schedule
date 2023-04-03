# frozen_string_literal: true

module REST
  class API
    class Shifts
      class Delete < Base
        desc "Cancel a shift"
        route_param :id do
          delete do
            status 204
            shift = ::Shift.find_by(external_id: params[:id])
            shift.destroy!
          end
        end
      end
    end
  end
end
