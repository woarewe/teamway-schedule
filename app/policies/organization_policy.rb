# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  alias create? admin?
end
