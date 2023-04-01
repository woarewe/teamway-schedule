# frozen_string_literal: true

class ApplicationPolicy
  def initialize(user, object = nil)
    @user = user
    @object = object
  end

  private

  attr_reader :user, :object

  def admin?
    case user
    when Admin then true
    else false
    end
  end
end
