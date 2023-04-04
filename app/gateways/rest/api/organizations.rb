# frozen_string_literal: true

module REST
  class API
    class Organizations < Grape::API
      format "json"

      helpers do
        def find_requested_organization!
          params => { id: external_id }
          @requested_organization = Organization.find_by(external_id:)
          not_found!(:id) if @requested_organization.nil?
        end

        attr_reader :requested_organization
      end

      mount Create

      route_param :id do
        before do
          find_requested_organization!
        end

        namespace(:shifts) { mount Shifts }
      end
    end
  end
end
