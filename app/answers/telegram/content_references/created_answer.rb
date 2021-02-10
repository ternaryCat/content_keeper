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
          [
            { text: I18n.t('bot.keyboard.edit_content_name'), callback_data: "edit_content-target:name:id:#{content.id}" },
            { text: I18n.t('bot.keyboard.destroy_content'), callback_data: "destroy_content-id:#{content.id}" }
          ],
          [
            { text: I18n.t('bot.keyboard.attach_tag'), callback_data: "attach_tag_#{content.id}" },
            { text: I18n.t('bot.keyboard.contents'), callback_data: 'contents' }
          ],
          [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
        ]
      end
    end
  end
end
