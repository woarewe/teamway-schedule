# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  alias organization object

  alias create? admin?
end
