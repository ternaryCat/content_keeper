module Telegram
  module Tags
    class DeleteAnswer < BaseAnswer
      param :tag

      def render
        super
        controller.respond_with :message, text: I18n.t('bot.tag.delete'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[
          button(I18n.t('bot.keyboard.cancel'), 'cancel_deleting_tag', id: tag.id, mode: :edit),
          button(I18n.t('bot.keyboard.delete'), 'destroy_tag', id: tag.id, mode: :edit)
        ]]
      end
    end
  end
end
