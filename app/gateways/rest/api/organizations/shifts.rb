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
          end
        end

        class Contract < Dry::Validation::Contract
          MAX_PERIOD = 31

          params do
            required(:from).filled(:date_time)
            required(:to).filled(:date_time)
          end

          rule(:from, :to) do
            next if values[:to] - values[:from] > MAX_PERIOD.days

            key(:period).failure(I18n.t!("rest.api.organizations.shifts.errors.long_period", period: MAX_PERIOD))
          end
        end

        desc "Get organization shifts"
        get do
          authorize! requested_organization, to: :view_shifts, with: OrganizationPolicy
          filters = validate!(params, with: Contract)
          present select_shifts(filters), with: Serialization::Shift
        end
      end
    end
  end
end
