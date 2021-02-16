module Telegram
  module Webhook
    class HelpAnswer < BaseAnswer
      def render
        controller.respond_with :message, text: I18n.t('bot.help'),
                                          reply_markup: { keyboard: keyboard, resize_keyboard: true }
        controller.respond_with :message, text: I18n.t('bot.menu'), reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [{ text: I18n.t('bot.keyboard.new_content'), callback_data: 'new_content' }],
          [
            { text: I18n.t('bot.keyboard.find_content'), callback_data: 'find_content' },
            { text: I18n.t('bot.keyboard.contents'), callback_data: 'contents' }
          ],
          [
            { text: I18n.t('bot.keyboard.new_tag'), callback_data: 'new_tag' },
            { text: I18n.t('bot.keyboard.tags'), callback_data: 'tags' }
          ]
        ]
      end

      def keyboard
        [[I18n.t('bot.keyboard.help'), I18n.t('bot.keyboard.about')]]
      end
    end
  end
end
