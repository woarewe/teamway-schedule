# frozen_string_literal: true

module REST
  class API
    class Organizations
      class Workers < Base
        desc "Get organization workers"
        get do
          authorize! requested_organization, to: :view_workers, with: OrganizationPolicy
          pagination_params!(params) => { page:, per_page: }
          present_paginated(requested_organization.workers, page:, per_page:, with: Serialization::Worker)
        end
      end
    end
  end
end
