class Authentication < ApplicationRecord
  include AuthenticationPresenter

  validates :provider, presence: true
  validates :uid, presence: true

  has_many :content_references, dependent: :destroy
  has_many :feedbacks, dependent: :nullify
  belongs_to :user
end
