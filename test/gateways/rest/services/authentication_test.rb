# frozen_string_literal: true

require "test_helper"

class REST::Services::AuthenticationTest < ActiveSupport::TestCase
  include Tests::Helpers::Authentication

  setup do
    @credentials = create_credentials
  end

  test "when there is no required header provided" do
    error = assert_raises(target_class::Error) { execute({}) }
    assert_match(/Header "\w+" is missing/, error.message)
  end

  test "when wrong authentication schema" do
    @credentials => { username:, password: }
    token = create_token(username, password)

    error = assert_raises(target_class::Error) { execute(with_auth_header("Digest", token)) }
    assert_match(/Invalid payload for the header \w+/, error.message)
  end

  test "when invalid base64 token" do
    token = "invalid base 64 string"
    error = assert_raises(target_class::Error) { execute(with_auth_header("Bearer", token)) }
    assert_match(/Invalid payload for the header \w+/, error.message)
  end

  test "when username is incorrect" do
    @credentials => { password: }
    token = create_token(Faker::Internet.unique.username, password)

    error = assert_raises(target_class::Error) { execute(with_auth_header("Bearer", token)) }
    assert_match(/Invalid username or password/, error.message)
  end

  test "when password is incorrect" do
    @credentials => { username: }
    token = create_token(username, Faker::Internet.unique.password)

    error = assert_raises(target_class::Error) { execute(with_auth_header("Bearer", token)) }
    assert_match(/Invalid username or password/, error.message)
  end

  test "when everything alright" do
    @credentials => { username:, password:, owner: }
    token = create_token(username, password)
    assert_equal(
      owner,
      execute(with_auth_header("Bearer", token))
    )
  end

  private

  def target_class
    REST::Services::Authentication
  end

  def instance
    target_class.new
  end

  def execute(...)
    instance.call(...)
  end
end
