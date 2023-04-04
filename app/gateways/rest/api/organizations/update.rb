# frozen_string_literal: true

module REST
  class API
    class Organizations
      class Update < Base
        class Contract < Dry::Validation::Contract
          json do
            required(:attributes).hash(Validation::Organization::Attributes.json)
          end
        end

        desc "Update an organization"
        put do
          authorize! requested_organization, to: :update, with: OrganizationPolicy
          validate!(params, with: Contract) => { attributes: }

          if requested_organization.update(attributes)
            present requested_organization, with: Serialization::Organization
          else
            wrapped_error!(requested_organization.errors.as_json, 422, as: :attributes)
          end
        end
      end
    end
  end
end
