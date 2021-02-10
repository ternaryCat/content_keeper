module Telegram
  module Users
    class StartAlreadyExistsAnswer < BaseAnswer
      def render
        controller.respond_with :message, text: I18n.t('bot.user.already_exists'), reply_markup: {
          inline_keyboard: inline_keyboard,
          keyboard: keyboard,
          resize_keyboard: true,
          selective: true
        }
      end

      private

      def inline_keyboard
        [[{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]]
      end

      def keyboard
        [[I18n.t('bot.keyboard.help'), I18n.t('bot.keyboard.about')]]
      end
    end
  end
end
