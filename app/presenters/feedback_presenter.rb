module FeedbackPresenter
  def preview
    text.slice(0..50)
  end

  delegate :uid, :title, :provider, to: :authentication, prefix: true, allow_nil: true
end
