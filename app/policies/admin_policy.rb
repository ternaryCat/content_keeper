class AdminPolicy < ApplicationPolicy
  def dashboard?
    user.admin?
  end

  def debug?
    user.admin?
  end
end
