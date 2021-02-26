module Telegram
  module Feedbacks
    class NewAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.feedback.new'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[button(I18n.t('bot.keyboard.help'), 'help'), button(I18n.t('bot.keyboard.close'), 'close')]]
      end
    end
  end
end
