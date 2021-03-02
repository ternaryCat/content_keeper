module Telegram
  module Admins
    class DebugAnswer < BaseAnswer
      param :current_authentication

      def render
        super
        controller.respond_with :message, text: current_authentication.to_json,
                                          reply_markup: { inline_keyboard: default_inline_keyboard }
      end
    end
  end
end
