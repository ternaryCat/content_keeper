module Telegram
  module Tags
    class DeletedAnswer < BaseAnswer
      def render
        controller.respond_with :message, text: I18n.t('bot.tag.deleted'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [
            { text: I18n.t('bot.keyboard.new_tag'), callback_data: 'new_tag' },
            { text: I18n.t('bot.keyboard.tags'), callback_data: 'tags' }
          ],
          [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
        ]
      end
    end
  end
end
