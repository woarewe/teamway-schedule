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

    assert_creating_shift_with_correct_attributes(shift)
    assert_response 201
  end

  test "preventing booking another shift for the same day when the existing one starts" do
    shift = build(:shift, :overnight, worker:)
    execute(payload(worker, shift))
    another_shift = build(:shift, :same_day, in_zone_time: shift.start_at, worker:)

    execute(payload(worker, another_shift))

    assert_response_with_double_book_error(another_shift)
  end

  test "preventing booking another shift for the same day when the existing one ends" do
    shift = build(:shift, :overnight, worker:)
    execute(payload(worker, shift))
    another_shift = build(:shift, :same_day, in_zone_time: shift.end_at, worker:)

    execute(payload(worker, another_shift))

    assert_response_with_double_book_error(another_shift)
  end

  test "preventing booking a shift in the past" do
    shift = build(:shift, :in_past, worker:)

    execute(payload(worker, shift))

    assert_response_with_booking_in_past_error
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

  def booked_shift
    @booked_shift ||= Shift.find_by(external_id: response_body.fetch(:id))
  end

  def response_body
    JSON.parse(@response.body).with_indifferent_access
  end

  def assert_response_with_double_book_error(payload)
    error = response_body.dig(:attributes, :start_at, 0)
    date = payload.start_at.in_time_zone(worker.time_zone).to_date

    assert_response 422
    assert_match(/already/, error)
    assert_match(/#{date.iso8601}/, error)
  end

  def assert_creating_shift_with_correct_attributes(expected)
    assert_equal expected.start_at, booked_shift.start_at
    assert_equal expected.end_at.round, booked_shift.end_at
    assert_equal worker.id, booked_shift.worker.id
  end

  def assert_response_with_booking_in_past_error
    error = response_body.dig(:attributes, :start_at, 0)

    assert_response 422
    assert_match(/past/, error)
  end
end
