# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  alias organization object

  alias create? admin?

  def view_shifts?
    admin? || organization.manager?(user)
  end
end
