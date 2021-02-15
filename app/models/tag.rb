class Tag < ApplicationRecord
  has_many :content_references_tags, dependent: :destroy
  has_many :content_references, through: :content_references_tags
  belongs_to :user
end
