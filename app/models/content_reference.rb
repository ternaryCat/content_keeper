class ContentReference < ApplicationRecord
  validates :token, presence: true

  has_many :content_references_tags, dependent: :destroy
  has_many :tags, through: :content_references_tags
  belongs_to :authentication
end
