module Telegram
  module ContentReferencesTags
    class DuplicateAnswer < BaseAnswer
      param :content

      def render
        controller.respond_with :message, text: I18n.t('bot.content_reference.attacheded_tag_duplicates'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [button(I18n.t('bot.keyboard.attach_other_tag'), 'attach_tags_list', content_id: content.id)],
          [button(I18n.t('bot.keyboard.contents'), 'contents')],
          [button(I18n.t('bot.keyboard.help'), 'help')]
        ]
      end
    end
  end
end
