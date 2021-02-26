module Feedbacks
  class Create < BaseService
    class Error < RuntimeError; end

    option :authentication
    option :text

    def call
      feedback = Feedback.create params
      raise Error unless feedback.persisted?

      feedback
    end

    private

    def params
      { authentication: authentication, text: text, state: :opened }
    end
  end
end
