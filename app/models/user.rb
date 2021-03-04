class User < ApplicationRecord
  include UserPresenter

  has_many :authentications, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :metrics, dependent: :nullify

  enum role: { user: 0, admin: 1 }
  enum plan_type: { free: 0, starter: 1, pro: 2 }
end
