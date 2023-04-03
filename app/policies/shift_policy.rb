# frozen_string_literal: true

class ShiftPolicy < ApplicationPolicy
  alias shift object

  def create?
    admin? || user.manager_of?(worker)
  end

  alias delete? create?

  private

  def worker
    return context.fetch(:worker) if shift.nil?

    shift.worker
  end
end
