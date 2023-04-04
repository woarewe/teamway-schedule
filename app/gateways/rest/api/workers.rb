# frozen_string_literal: true

module REST
  class API
    class Workers < Grape::API
      format "json"

      helpers do
        def find_requested_worker!
          params => { id: external_id }
          @requested_worker = ::Worker.find_by(external_id:)
          not_found!(:id) if @requested_worker.nil?
        end

        attr_reader :requested_worker
      end

      mount Create

      route_param :id do
        before do
          find_requested_worker!
        end

        namespace(:shifts) { mount Shifts }

        mount Update
        mount Delete
        mount Get
      end
    end
  end
end
