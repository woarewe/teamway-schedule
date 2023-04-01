# frozen_string_literal: true

class Organization::ManagerPredicateTest < ActiveSupport::TestCase
  setup do
    @organization = create(:organization)
    create_list(:worker, 3, :regular, organization:)
    create_list(:worker, 3, :manager, organization:)
  end

  test "when a worker is a regular worker" do
    worker = create(:worker, :regular, organization:)
    assert_not execute(worker)
  end

  test "when a worker is a manager" do
    worker = create(:worker, :manager, organization:)
    assert execute(worker)
  end

  test "when a worker is a manager of another organization" do
    another_organization = create(:organization)
    worker = create(:worker, :manager, organization: another_organization)
    assert_not execute(worker)
  end

  private

  attr_reader :organization

  def execute(worker)
    organization.manager?(worker)
  end
end
