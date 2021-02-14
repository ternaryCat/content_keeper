class User < ApplicationRecord
  has_many :authentications, dependent: :destroy
  has_many :tags, dependent: :destroy
end
