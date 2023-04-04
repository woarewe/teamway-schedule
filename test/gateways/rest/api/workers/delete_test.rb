# frozen_string_literal: true

require "test_helper"

class REST::API::Workers::DeleteTest < ActionDispatch::IntegrationTest
  include Tests::Helpers::API
  include Tests::Helpers::Authentication
  include Tests::Helpers::Workers

  setup do
    @organization = create(:organization)
    @manager = create(:worker, :manager, organization: @organization)
    @credentials = create_credentials(owner: @manager)
  end

  test "deleting an existing new worker" do
    worker = create(:worker, organization: @organization)

    execute(worker.external_id)

    assert_nil ::Worker.find_by(id: worker.id)
  end

  private

  def execute(worker_id)
    delete(
      "/api/workers/#{worker_id}",
      headers: headers_with_auth(@credentials)
    )
  end
end
