# frozen_string_literal: true

class BaseOperation
  class DuplicationError < StandardError
    attr_reader :columns

    def initialize(columns)
      @columns = columns
      super("")
    end
  end

  private

  def handle_duplication_error
    yield
  rescue ActiveRecord::RecordNotUnique => error
    columns = parse_unique_constrain_columns(error)
    raise DuplicationError, columns
  end

  def parse_unique_constrain_columns(error)
    result = /Key \((?<columns>.*?)\)/.match(error.message)
    result[:columns].split(", ").map(&:to_sym)
  end
end
