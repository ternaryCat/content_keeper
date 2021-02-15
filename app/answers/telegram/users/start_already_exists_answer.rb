module Telegram
  module Users
    class StartAlreadyExistsAnswer < BaseAnswer
      def render
        controller.respond_with :message, text: I18n.t('bot.user.already_exists'), reply_markup: {
          keyboard: keyboard,
          resize_keyboard: true
        }
      end

      private

      def keyboard
        [[I18n.t('bot.keyboard.help'), I18n.t('bot.keyboard.about')]]
      end
    end
  end
end
