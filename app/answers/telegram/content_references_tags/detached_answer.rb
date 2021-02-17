module Telegram
  module ContentReferencesTags
    class DetachedAnswer < BaseAnswer
      param :content
      param :tag

      def render
        controller.respond_with :message, text: I18n.t('bot.content_references_tag.detached', tag_name: tag.name),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [
            { text: I18n.t('bot.content_reference.keyboard.back'), callback_data: "show_content-id:#{content.id}" },
            {
              text: I18n.t('bot.content_reference.keyboard.detach_more'),
              callback_data: "detach_tags_list-content_id:#{content.id}"
            }
          ],
          [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
        ]
      end
    end
  end
end
