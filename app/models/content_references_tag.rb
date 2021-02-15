class ContentReferencesTag < ApplicationRecord
  belongs_to :content_reference
  belongs_to :tag
end
