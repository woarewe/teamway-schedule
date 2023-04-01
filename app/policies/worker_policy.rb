# frozen_string_literal: true

class WorkerPolicy < ApplicationPolicy
  alias worker object

  def create?
    admin? || organization.manager?(user)
  end

  def update?
    admin? || organization.manager?(user) || owner?
  end

  alias delete? create?

  private

  def organization
    return context.fetch(:organization) if worker.nil?

    worker.organization
  end

  def owner?
    current_user == worker
  end
end
