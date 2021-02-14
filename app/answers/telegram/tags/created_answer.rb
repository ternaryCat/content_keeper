module Telegram
  module Tags
    class CreatedAnswer < BaseAnswer
      param :tag

      def render
        controller.respond_with :message, text: I18n.t('bot.tag.created'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          *edit_keyboard,
          [
            { text: I18n.t('bot.tag.keyboard.create_more'), callback_data: 'new_tag' },
            { text: I18n.t('bot.keyboard.tags'), callback_data: 'tags' }
          ],
          [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
        ]
      end

      def edit_keyboard
        [
          [
            { text: I18n.t('bot.keyboard.rename'), callback_data: "edit_tag-target:name:id:#{tag.id}" },
            { text: I18n.t('bot.keyboard.delete'), callback_data: "delete_tag-id:#{tag.id}" }
          ]
        ]
      end
    end
  end
end
