class User < ApplicationRecord
  has_many :authentications, dependent: :destroy
end
