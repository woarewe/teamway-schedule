# frozen_string_literal: true

module REST
  class API
    class Organizations
      class Create < Base
        class Contract < Dry::Validation::Contract
          json do
            required(:attributes).hash(Validation::Organization::Attributes.json)
          end
        end

        desc "Create an organization"
        post do
          authorize! to: :create, with: OrganizationPolicy

          payload = validate!(params, with: Contract)
          payload => { attributes: }
          organization = ::Organization.new(attributes)

          if organization.save
            present organization, with: Serialization::Organization
          else
            wrapped_error!(organization.errors.as_json, 422, as: :attributes)
          end
        end
      end
    end
  end
end
