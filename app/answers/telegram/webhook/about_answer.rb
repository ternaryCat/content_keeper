module Telegram
  module Webhook
    class AboutAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.about'), reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [help_answer, button(I18n.t('bot.keyboard.feedback'), 'feedback')],
          [close_button]
        ]
      end
    end
  end
end
