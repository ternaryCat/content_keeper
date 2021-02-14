module Telegram
  module ContentReferences
    class CanceledDeletingAnswer < BaseAnswer
      def render
        controller.respond_with :message, text: I18n.t('bot.content_reference.canceled_deleting'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]]
      end
    end
  end
end
