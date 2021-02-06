class ContentReference < ApplicationRecord
  validates :token, presence: true

  belongs_to :authentication
end
