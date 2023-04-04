# frozen_string_literal: true

module Tests
  module Helpers
    module Organizations
      def assert_no_new_organizations(&)
        assert_no_changes(
          -> { organizations_count },
          &
        )
      end

      def assert_new_organization(&)
        assert_changes(
          -> { organizations_count },
          from: organizations_count,
          to: organizations_count + 1,
          &
        )
      end

      def organizations_count
        ::Organization.count
      end

      def saved_organization
        Organization.find_by(external_id: response_body.fetch(:id))
      end
    end
  end
end
