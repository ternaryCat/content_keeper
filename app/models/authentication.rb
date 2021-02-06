class Authentication < ApplicationRecord
  validates :provider, presence: true
  validates :uid, presence: true

  has_many :content_references, dependent: :destroy
  belongs_to :user
end
