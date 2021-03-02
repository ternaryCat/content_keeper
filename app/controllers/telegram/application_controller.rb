module Telegram
  class ApplicationController < Telegram::Bot::UpdatesController
    include Telegram::Bot::UpdatesController::MessageContext
    include Pundit

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def current_user
      @current_user ||= current_authentication&.user
    end

    def current_authentication
      @current_authentication ||= Authentication.find_by provider: :telegram, uid: from['id']
    end

    protected

    def parse_action(action)
      action_name, raw_options = action.split('-')
      return [action_name, {}] unless raw_options

      options = Hash[*raw_options.split(':')]
      [action_name, options.symbolize_keys]
    end

    def global_session
      @@_global_session ||= self.class.superclass.build_session(session_key) # rubocop:disable Style/ClassVars
    end

    private

    def user_not_authorized
      UserNotAuthorizedAnswer.render self
    end
  end
end
