module Telegram
  module Tags
    class NotFoundAnswer < BaseAnswer
      def render
        controller.respond_with :message, text: I18n.t('bot.tag.not_found'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [{ text: I18n.t('bot.keyboard.tags'), callback_data: 'tags' }],
          [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
        ]
      end
    end
  end
end
