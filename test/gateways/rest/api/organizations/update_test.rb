# frozen_string_literal: true

require "test_helper"

class REST::API::Organizations::UpdateTest < ActionDispatch::IntegrationTest
  include Tests::Helpers::API
  include Tests::Helpers::Authentication
  include Tests::Helpers::Organizations

  setup do
    @credentials = create_credentials(owner: create(:admin))
  end

  test "updating an organization name" do
    old_name = Faker::Company.unique.name
    organization = create(:organization, name: old_name)
    new_name = Faker::Company.name

    assert_no_new_organizations { execute(organization.external_id, new_name) }
    assert_equal new_name, organization.reload.name
  end

  test "not updating an organization name to the already existing one" do
    old_name = Faker::Company.unique.name
    organization = create(:organization, name: old_name)
    new_name = Faker::Company.name
    create(:organization, name: new_name)

    assert_no_new_organizations { execute(organization.external_id, new_name) }
    assert_equal old_name, organization.reload.name
  end

  private

  def execute(external_id, name)
    put(
      "/api/organizations/#{external_id}",
      params: { attributes: { name: } },
      headers: headers_with_auth(@credentials)
    )
  end
end
