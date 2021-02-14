module Telegram
  module Tags
    class DeleteAnswer < BaseAnswer
      param :tag

      def render
        controller.respond_with :message, text: I18n.t('bot.tag.delete'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[
          { text: I18n.t('bot.keyboard.cancel'), callback_data: "cancel_deleting_tag-id:#{tag.id}" },
          { text: I18n.t('bot.keyboard.delete'), callback_data: "destroy_tag-id:#{tag.id}" }
        ]]
      end
    end
  end
end
