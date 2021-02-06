module Telegram
  class ApplicationController < Telegram::Bot::UpdatesController
    include Telegram::Bot::UpdatesController::MessageContext
    # TO DO: refactor for production
    self.session_store = :file_store, './storage'

    def current_user
      @current_user ||= current_authentication&.user
    end

    def current_authentication
      @current_authentication ||= Authentication.find_by provider: :telegram, uid: from['id']
    end

    protected

    def global_session
      @@_global_session ||= self.class.superclass.build_session(session_key)
    end
  end
end
