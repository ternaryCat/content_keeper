module Telegram
  module ContentReferences
    class CreatedAnswer < BaseAnswer
      param :content

      def render
        controller.respond_with :message, text: I18n.t('bot.content_reference.created'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          *edit_keyboard,
          [
            { text: I18n.t('bot.keyboard.attach_tag'), callback_data: "attach_tag-content:#{content.id}" },
            { text: I18n.t('bot.keyboard.contents'), callback_data: 'contents' }
          ],
          [{ text: I18n.t('bot.content_reference.keyboard.create_more'), callback_data: 'new_content' }],
          [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
        ]
      end

      def edit_keyboard
        [
          [
            { text: I18n.t('bot.keyboard.name'), callback_data: "edit_content-target:name:id:#{content.id}" },
            { text: I18n.t('bot.keyboard.delete'), callback_data: "delete_content-id:#{content.id}" }
          ]
        ]
      end
    end
  end
end
