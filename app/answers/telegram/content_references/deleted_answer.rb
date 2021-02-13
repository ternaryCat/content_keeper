module Telegram
  module ContentReferences
    class DeletedAnswer < BaseAnswer
      def render
        controller.respond_with :message, text: I18n.t('bot.content_reference.deleted'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [
            { text: I18n.t('bot.keyboard.new_content'), callback_data: 'new_content' },
            { text: I18n.t('bot.keyboard.contents'), callback_data: 'contents' }
          ],
          [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
        ]
      end
    end
  end
end
