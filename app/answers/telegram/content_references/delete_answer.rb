module Telegram
  module ContentReferences
    class DeleteAnswer < BaseAnswer
      param :content

      def render
        controller.respond_with :message, text: I18n.t('bot.content_reference.delete'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[
          { text: I18n.t('bot.keyboard.cancel'), callback_data: "cancel_deleting_content-id:#{content.id}" },
          { text: I18n.t('bot.content_reference.keyboard.delete'), callback_data: "destroy_content-id:#{content.id}" }
        ]]
      end
    end
  end
end
