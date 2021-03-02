class AdminPolicy < ApplicationPolicy
  def dashboard?
    user.admin?
  end
end
