# frozen_string_literal: true

module REST
  class API
    class Organizations
      class Delete < Base
        desc "Delete an organization"
        delete do
          status 204
          authorize! requested_organization, to: :delete, with: OrganizationPolicy
          requested_organization.destroy!
        end
      end
    end
  end
end
