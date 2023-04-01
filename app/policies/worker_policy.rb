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

  def show?
    admin? || organization.worker?(user)
  end

  private

  def organization
    return context.fetch(:organization) if worker.nil?

    worker.organization
  end

  def owner?
    current_user == worker
  end
end
