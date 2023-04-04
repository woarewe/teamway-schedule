# frozen_string_literal: true

require "test_helper"

class REST::API::Organizations::CreateTest < ActionDispatch::IntegrationTest
  include Tests::Helpers::API
  include Tests::Helpers::Authentication
  include Tests::Helpers::Organizations

  setup do
    @credentials = create_credentials(owner: create(:admin))
  end

  test "creating a new organization" do
    name = Faker::Company.name

    assert_new_organization { execute(name) }
    assert_equal saved_organization.name, name
  end

  test "not creating a new organization with an empty name" do
    assert_no_new_organizations { execute("") }
  end

  test "not creating a new organization with an duplicated name" do
    organization = create(:organization)

    assert_no_new_organizations { execute(organization.name) }
  end

  private

  def execute(name)
    post(
      "/api/organizations",
      params: { attributes: { name: } },
      headers: headers_with_auth(@credentials)
    )
  end
end
