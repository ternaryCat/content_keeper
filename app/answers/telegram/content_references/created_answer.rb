module Telegram
  module ContentReferences
    class CreatedAnswer < BaseAnswer
      param :content

      def render
        super
        controller.respond_with :message, text: I18n.t('bot.content_reference.created'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
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
          [button(I18n.t('bot.keyboard.help'), 'help')]
        ]
      end
    end
  end
end
