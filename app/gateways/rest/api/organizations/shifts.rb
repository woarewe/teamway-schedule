# frozen_string_literal: true

module REST
  class API
    class Organizations
      class Shifts < Base
        helpers do
          def select_shifts(filters)
            filters => { from:, to: }
            ::Shift
              .includes(:worker)
              .for_organization(requested_organization)
              .between(from, to)
              .chronologically
              .serial
          end
        end

        desc "Get organization shifts"
        get do
          authorize! requested_organization, to: :view_shifts, with: OrganizationPolicy
          filters = validate!(params, with: Validation::Shift::Filter)
          present select_shifts(filters), with: Serialization::Shift
        end
      end
    end
  end
end
