module Telegram
  module ContentReferences
    class DeleteAnswer < BaseAnswer
      param :content

      def render
        super
        controller.respond_with :message, text: I18n.t('bot.content_reference.delete'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[
          button(I18n.t('bot.keyboard.cancel'), 'cancel_deleting_content', id: content.id),
          button(I18n.t('bot.keyboard.delete'), 'destroy_content', id: content.id)
        ]]
      end
    end
  end
end
