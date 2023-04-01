# frozen_string_literal: true

class ApplicationPolicy
  def initialize(user, object = nil, **context)
    @user = user
    @object = object
    @context = context
  end

  private

  attr_reader :user, :object, :context

  def admin?
    case user
    when Admin then true
    else false
    end
  end
end
