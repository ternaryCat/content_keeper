class User < ApplicationRecord
  has_many :authentications, dependent: :destroy
  has_many :tags, dependent: :destroy

  enum role: { user: 0, admin: 1 }
end
