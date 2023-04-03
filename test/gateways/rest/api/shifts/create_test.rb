# frozen_string_literal: true

require "test_helper"

class REST::API::Shifts::CreateTest < ActionDispatch::IntegrationTest
  include Tests::Helpers::Authentication

  setup do
    @worker = create(:worker)
  end

  test "creating a new shift for a worker" do
    shift = build(:shift, worker:)

    execute(payload(worker, shift))

    # assert_equal shift.start_at.change(), created_shift.start_at
    # assert_equal shift.end_at.round, created_shift.end_at
    # assert_equal worker.id, created_shift.worker.id
  end

  test "preventing booking another shift for the same day when the existing one starts" do
    shift = build(:shift, :overnight, worker:)

    execute(payload(worker, shift))
    assert_response :success

    another_shift = build(:shift, :same_day, in_zone_time: shift.start_at, worker:)
    execute(payload(worker, another_shift))
    assert_response 422
  end

  test "preventing booking another shift for the same day when the existing one ends" do
    shift = build(:shift, :overnight, worker:)

    execute(payload(worker, shift))
    assert_response :success

    another_shift = build(:shift, :same_day, in_zone_time: shift.end_at, worker:)
    execute(payload(worker, another_shift))
    assert_response 422
  end

  test "preventing booking a shift in the past" do
    shift = build(:shift, :in_past, worker:)
    execute(payload(worker, shift))
    assert_response 422
  end

  private

  attr_reader(
    :worker
  )

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
