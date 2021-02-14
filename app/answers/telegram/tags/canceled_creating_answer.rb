module Telegram
  module Tags
    class CanceledCreatingAnswer < BaseAnswer
      def render
        controller.respond_with :message, text: I18n.t('bot.tag.canceled_creating'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]]
      end
    end
  end
end
