module Telegram
  module Tags
    class ShowAnswer < BaseAnswer
      param :tag

      def render
        super
        controller.respond_with :message, text: tag.name, reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [
            button(I18n.t('bot.keyboard.rename'), 'edit_tag', target: :name, id: tag.id),
            button(I18n.t('bot.keyboard.delete'), 'delete_tag', id: tag.id)
          ],
          [button(I18n.t('bot.tag.keyboard.contents'), 'contents', tag_id: tag.id)],
          [button(I18n.t('bot.keyboard.help'), 'help')],
          [button(I18n.t('bot.keyboard.close'), 'close')]
        ]
      end
    end
  end
end
