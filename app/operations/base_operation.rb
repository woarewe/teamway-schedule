# frozen_string_literal: true

class BaseOperation
  ExclusionError = Class.new(StandardError)

  private

  def handle_exclusion_constraint(constraint_name)
    yield
  rescue ActiveRecord::StatementInvalid => error
    prevent_handling_unexpected_errors(error, constraint_name)
    raise ExclusionError
  end

  def prevent_handling_unexpected_errors(error, constraint_name)
    original_error = error.cause
    raise error unless original_error.is_a?(PG::ExclusionViolation)

    name = constraint_name(original_error)
    raise error if name != constraint_name
  end

  def constraint_name(error)
    /exclusion constraint "(?<constraint_name>\w+)"/
      .match(error.message)
      .then { |result| result[:constraint_name] }
  end
end
