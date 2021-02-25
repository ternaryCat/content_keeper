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
          [
            button(I18n.t('bot.keyboard.rename'), 'edit_tag', target: :name, id: tag.id),
            button(I18n.t('bot.keyboard.delete'), 'delete_tag', id: tag.id)
          ],
          [button(I18n.t('bot.tag.keyboard.create_more'), 'new_tag'), button(I18n.t('bot.keyboard.tags'), 'tags')],
          [button(I18n.t('bot.keyboard.help'), 'help')]
        ]
      end
    end
  end
end
