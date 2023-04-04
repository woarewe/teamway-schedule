# frozen_string_literal: true

require "test_helper"

class REST::API::Workers::UpdateTest < ActionDispatch::IntegrationTest
  include Tests::Helpers::API
  include Tests::Helpers::Authentication
  include Tests::Helpers::Workers

  setup do
    @organization = create(:organization)
    @manager = create(:worker, :manager, organization: @organization)
    @credentials = create_credentials(owner: @manager)
  end

  test "updating an existing new worker" do
    worker = create(:worker, organization: @organization)
    attributes = valid_worker_attributes

    assert_no_new_workers(@organization) { execute(worker.external_id, attributes) }

    attributes => { first_name:, last_name:, role:, }
    worker.reload
    assert_equal first_name, worker.first_name
    assert_equal last_name, worker.last_name
    assert_equal role, worker.role
  end

  private

  def execute(worker_id, attributes)
    put(
      "/api/workers/#{worker_id}",
      params: { attributes: },
      headers: headers_with_auth(@credentials)
    )
  end
end
