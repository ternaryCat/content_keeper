class Feedback < ApplicationRecord
  include FeedbackPresenter

  validates :text, presence: true
  belongs_to :authentication
  enum state: { opened: 0, closed: 1 }
end
