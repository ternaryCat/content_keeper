module Telegram
  module Webhook
    class CloseAnswer < BaseAnswer
      param :chat_id
      param :message_id

      def render
        super
        controller.bot.delete_message(chat_id: chat_id, message_id: message_id)
      end
    end
  end
end
