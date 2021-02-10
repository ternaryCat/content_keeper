module Telegram
  module Webhook
    class DebugAnswer < BaseAnswer
      param :current_authentication

      def render
        controller.respond_with :message, text: current_authentication.to_json
      end
    end
  end
end
