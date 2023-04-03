# frozen_string_literal: true

require "test_helper"

class REST::API::Shifts::CreateTest < ActionDispatch::IntegrationTest
  include Tests::Helpers::Authentication
  include Tests::Helpers::Shifts

  setup do
    @worker = create(:worker)
    @another_worker = create(:worker)
    @credentials = create_credentials(owner: create(:admin))
  end

  test "creating a new shift for a worker" do
    local_start = far_future_local_time(@worker.time_zone)

    assert_new_shift(@worker) { execute(@worker, local_start) }
    assert_saving_shift_with_correct_attributes(booked_shift, @worker, local_start)
    assert_response 201
  end

  test "creating a new overnight shift for a worker" do
    local_start = over_night_shift_local_start(@worker.time_zone)

    assert_new_shift(@worker) { execute(@worker, local_start) }
    assert_saving_shift_with_correct_attributes(booked_shift, @worker, local_start)
    assert_response 201
  end

  test "preventing booking another shift for the same day when the existing one starts" do
    local_start = far_future_local_time(@worker.time_zone)
    execute(@worker, local_start)
    same_day_local_start = local_start.beginning_of_day + 2.hours

    assert_no_new_shifts(@worker) { execute(@worker, same_day_local_start) }
    assert_response_with_double_book_error(same_day_local_start)
  end

  test "preventing booking another shift for the same day when the existing one ends" do
    local_start = over_night_shift_local_start(@worker.time_zone)
    execute(@worker, local_start)
    next_day_local_start = local_shift_end(local_start).end_of_day - 4.hours

    assert_no_new_shifts(@worker) { execute(@worker, next_day_local_start) }
    assert_response_with_double_book_error(next_day_local_start)
  end

  test "creating shifts on the same day by UTC but on other by worker's time zone" do
    time_zone = "Asia/Tbilisi"
    worker = create(:worker, time_zone:)
    future_local_time = far_future_local_time(time_zone)
    local_start = future_local_time.beginning_of_day + 2.hours

    assert_new_shift(worker) { execute(worker, local_start) }
    assert_saving_shift_with_correct_attributes(booked_shift, worker, local_start)

    previous_date_local_start = local_start.yesterday.beginning_of_day + 8.hours

    assert_new_shift(worker) { execute(worker, previous_date_local_start) }
    assert_saving_shift_with_correct_attributes(booked_shift, worker, previous_date_local_start)
  end

  test "preventing booking a shift in the past" do
    local_start = far_past_local_time(@worker.time_zone)

    assert_no_new_shifts(@worker) { execute(@worker, local_start) }
    assert_response_with_booking_in_past_error
  end

  private

  def execute(worker, local_start)
    post(
      "/api/shifts",
      params: payload(worker, local_start),
      headers: headers_with_auth(@credentials)
    )
  end

  def payload(worker, local_start)
    {
      worker_id: worker.external_id,
      attributes: {
        start_at: local_start.iso8601
      }
    }
  end

  def booked_shift
    Shift.find_by(external_id: response_body.fetch(:id))
  end

  def response_body
    JSON.parse(@response.body).with_indifferent_access
  end

  def assert_response_with_double_book_error(local_start)
    error = response_body.dig(:attributes, :start_at, 0)

    assert_response 422
    assert_match(/already/, error)
    assert_match(/#{local_start.to_date.iso8601}/, error)
  end

  def assert_saving_shift_with_correct_attributes(shift, worker, local_start)
    assert_equal worker.id, shift.worker_id
    assert_equal shift.start_at, local_start.utc
    assert_equal shift.end_at, local_shift_end(local_start).utc
    assert_equal worker.id, shift.worker_id
  end

  def assert_response_with_booking_in_past_error
    error = response_body.dig(:attributes, :start_at, 0)

    assert_response 422
    assert_match(/past/, error)
  end
end
