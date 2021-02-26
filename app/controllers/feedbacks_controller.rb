class FeedbacksController < ApplicationController
  before_action :feedback, only: %i(show reply)

  def index
    @feedbacks = Feedback.opened.includes(:authentication).order(id: :desc).limit 100
  end

  def show; end

  def reply
    Feedbacks::Reply.call @feedback, answer: params[:answer]
    redirect_to feedbacks_path
  rescue Feedbacks::Reply::Error
    redirect_to @feedback
  end

  def closed
    @feedbacks = Feedback.closed.includes(:authentication).order(id: :desc).limit 100
  end

  private

  def feedback
    @feedback ||= Feedback.find params[:id]
  end
end
