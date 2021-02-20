module Telegram
  module ContentReferencesTags
    class AttachedAnswer < BaseAnswer
      param :content
      param :tag

      def render
        controller.respond_with :message, text: I18n.t('bot.content_reference.attached_tag', tag_name: tag.name),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [
            button(I18n.t('bot.content_reference.keyboard.back'), 'show_content', id: content.id),
            button(I18n.t('bot.keyboard.contents'), 'contents')
          ],
          [button(I18n.t('bot.content_reference.keyboard.attach_more'), 'attach_tags_list', content_id: content.id)],
          [button(I18n.t('bot.keyboard.help'), 'help')]
        ]
      end
    end
  end
end
