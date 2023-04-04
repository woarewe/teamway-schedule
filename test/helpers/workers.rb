# frozen_string_literal: true

module Tests
  module Helpers
    module Workers
      def valid_worker_attributes
        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name
        role = ::Worker::ROLES.to_a.sample
        time_zone = TZInfo::Timezone.all.sample.name

        { first_name:, last_name:, role:, time_zone: }
      end

      def assert_no_new_workers(organization, &)
        assert_no_changes(
          -> { workers_count(organization) },
          &
        )
      end

      def assert_new_worker(organization, &)
        assert_changes(
          -> { workers_count(organization) },
          from: workers_count(organization),
          to: workers_count(organization) + 1,
          &
        )
      end

      def saved_worker
        ::Worker.find_by(external_id: response_body.fetch(:id))
      end

      def workers_count(organization)
        ::Worker.where(organization:).count
      end
    end
  end
end
