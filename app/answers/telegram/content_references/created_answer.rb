module Telegram
  module ContentReferences
    class CreatedAnswer < BaseAnswer
      param :content

      def render
        super
        answer I18n.t('bot.content_reference.created'), { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [
            button(I18n.t('bot.keyboard.name'), 'edit_content', target: :name, id: content.id),
            button(I18n.t('bot.keyboard.delete'), 'delete_content', id: content.id)
          ],
          [
            button(I18n.t('bot.keyboard.attach_tag'), 'attach_tags_list', content_id: content.id),
            button(I18n.t('bot.keyboard.contents'), 'contents')
          ],
          [button(I18n.t('bot.content_reference.keyboard.create_more'), 'new_content')],
          *default_inline_keyboard
        ]
      end
    end
  end
end
