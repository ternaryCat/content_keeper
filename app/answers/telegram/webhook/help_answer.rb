module Telegram
  module Webhook
    class HelpAnswer < BaseAnswer
      def render
        controller.respond_with :message, text: I18n.t('bot.help'), reply_markup: { inline_keyboard: inline_keyboard }
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
            { text: I18n.t('bot.keyboard.create_tag'), callback_data: 'create_tag' },
            { text: I18n.t('bot.keyboard.list_tags'), callback_data: 'list_tags' }
          ]
        ]
      end
    end
  end
end
