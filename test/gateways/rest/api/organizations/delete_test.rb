# frozen_string_literal: true

require "test_helper"

class REST::API::Organizations::DeleteTest < ActionDispatch::IntegrationTest
  include Tests::Helpers::API
  include Tests::Helpers::Authentication
  include Tests::Helpers::Organizations

  setup do
    @credentials = create_credentials(owner: create(:admin))
  end

  test "deleting an organization" do
    organization = create(:organization)

    execute(organization.external_id)

    assert_nil Organization.find_by(id: organization.id)
  end

  private

  def execute(external_id)
    delete(
      "/api/organizations/#{external_id}",
      headers: headers_with_auth(@credentials)
    )
  end
end
