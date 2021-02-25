module Telegram
  module ContentReferences
    class ShowAnswer < BaseAnswer
      param :authentication
      param :content

      def render
        # you can use forwardMessage instead
        Telegram.bot.request(:copyMessage,
                             chat_id: authentication.uid,
                             from_chat_id: authentication.uid,
                             message_id: content.token,
                             reply_markup: { inline_keyboard: inline_keyboard })
      end

      private

      def inline_keyboard
        [*edit_keyboard, tags_keyboard, [button(I18n.t('bot.keyboard.help'), 'help')]]
      end

      def edit_keyboard
        [
          [
            button(I18n.t('bot.keyboard.edit'), 'edit_content', target: :token, id: content.id),
            button(I18n.t('bot.keyboard.rename'), 'edit_content', target: :name, id: content.id)
          ],
          [
            button(I18n.t('bot.keyboard.delete'), 'delete_content', id: content.id),
            button(I18n.t('bot.keyboard.attach_tag'), 'attach_tags_list', content_id: content.id)
          ]
        ]
      end

      def tags_keyboard
        [
          button(I18n.t('bot.content_reference.keyboard.detach_tags'), 'detach_tags_list', content_id: content.id),
          button(I18n.t('bot.content_reference.keyboard.attached_tags'), 'tags', content_id: content.id)
        ]
      end
    end
  end
end
