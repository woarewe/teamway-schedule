# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  alias organization object

  alias create? admin?

  def update?
    admin? || organization.manager?(user)
  end

  alias view_shifts? update?
  alias view_workers? update?
  alias delete? update?
end
