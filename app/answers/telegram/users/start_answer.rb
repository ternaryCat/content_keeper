module Telegram
  module Users
    class StartAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.welcome'), reply_markup: {
          keyboard: keyboard,
          resize_keyboard: true
        }
        controller.respond_with :message, text: I18n.t('bot.menu'), reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[button(I18n.t('bot.keyboard.help'), 'help')]]
      end

      def keyboard
        [[I18n.t('bot.keyboard.help'), I18n.t('bot.keyboard.about')]]
      end
    end
  end
end
