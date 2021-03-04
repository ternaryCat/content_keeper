module Telegram
  class FeedbacksController < ApplicationController
    def callback_query(data)
      callback_strategy(data.to_sym)&.call
    end

    def message(message)
      action = global_session[:last_action]&.dig(:args)&.first
      return unless action
      return if global_session[:last_action][:action] != 'callback_query'

      action_name, _options = parse_action(action)
      last_action_strategy(action_name.to_sym)&.call message['text']
    end

    private

    def callback_strategy(action)
      {
        feedback: -> { Feedbacks::NewAnswer.render self }
      }[action]
    end

    def last_action_strategy(action)
      {
        feedback: ->(message) { create_feedback(message) }
      }[action]
    end

    def create_feedback(message)
      ::Feedbacks::Create.call authentication: current_authentication, text: message
      Feedbacks::CreatedAnswer.render self
    rescue ::Feedbacks::Create::Error
      Feedbacks::ErrorAnswer.render self
    end
  end
end
