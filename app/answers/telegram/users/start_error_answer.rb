module Telegram
  module Users
    class StartErrorAnswer < BaseAnswer
      def render
        controller.respond_with :message, text: I18n.t('bot.user.created_error'), reply_markup: {
          inline_keyboard: inline_keyboard,
          keyboard: keyboard,
          resize_keyboard: true,
          selective: true
        }
      end

      private

      def inline_keyboard
        [[{ text: I18n.t('bot.about'), callback_data: 'about' }]]
      end

      def keyboard
        [[I18n.t('bot.keyboard.about')]]
      end
    end
  end
end
