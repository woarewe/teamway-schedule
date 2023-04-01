# frozen_string_literal: true

class WorkerPolicy < ApplicationPolicy
  alias worker object

  def create?
    admin? || organization.manager?(user)
  end

  private

  def organization
    return context.fetch(:organization) if worker.nil?

    worker.organization
  end
end
