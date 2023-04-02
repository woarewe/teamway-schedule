# frozen_string_literal: true

require "test_helper"

class REST::API::Shifts::CreateTest < ActionDispatch::IntegrationTest
  include Tests::Helpers::Authentication

  test "creating a new shift for a worker" do
    worker = create(:worker)
    shift = build(:shift)

    execute(payload(worker, shift))
    assert_equal shift.start_at, created_shift.start_at
    assert_equal shift.end_at.round, created_shift.end_at
    assert_equal worker.id, created_shift.worker.id
  end

  private

  def execute(payload)
    admin = create(:admin)
    credentials = create_credentials(owner: admin)
    post(
      "/api/shifts",
      params: payload,
      headers: headers_with_auth(credentials)
    )
  end

  def payload(worker, shift)
    {
      worker_id: worker.external_id,
      attributes: {
        start_at: shift.start_at.in_time_zone(worker.time_zone).iso8601
      }
    }
  end

  def created_shift
    @created_shift ||= Shift.find_by(external_id: response_body.fetch(:id))
  end

  def response_body
    JSON.parse(@response.body).with_indifferent_access
  end
end
