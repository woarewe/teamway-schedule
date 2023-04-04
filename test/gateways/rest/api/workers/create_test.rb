# frozen_string_literal: true

require "test_helper"

class REST::API::Workers::CreateTest < ActionDispatch::IntegrationTest
  include Tests::Helpers::API
  include Tests::Helpers::Authentication
  include Tests::Helpers::Workers

  setup do
    @organization = create(:organization)
    @manager = create(:worker, :manager, organization: @organization)
    @credentials = create_credentials(owner: @manager)
  end

  test "creating a new worker" do
    attributes = valid_worker_attributes

    assert_new_worker(@organization) { execute(@organization.external_id, attributes) }

    attributes => { first_name:, last_name:, role:, }
    assert_equal first_name, saved_worker.first_name
    assert_equal last_name, saved_worker.last_name
    assert_equal role, saved_worker.role
    assert_equal @organization, saved_worker.organization
  end

  test "not creating a worker with a blank first name" do
    attributes = valid_worker_attributes.merge(first_name: "")

    assert_no_new_workers(@organization) { execute(@organization.external_id, attributes) }
  end

  test "not creating a worker with a blank last name" do
    attributes = valid_worker_attributes.merge(last_name: "")

    assert_no_new_workers(@organization) { execute(@organization.external_id, attributes) }
  end

  private

  def execute(organization_id, attributes)
    post(
      "/api/workers",
      params: { organization_id:, attributes: },
      headers: headers_with_auth(@credentials)
    )
  end
end
