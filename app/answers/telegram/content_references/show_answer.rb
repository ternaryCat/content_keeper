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
        [
          *edit_keyboard,
          [*delete_keyboard, { text: I18n.t('bot.keyboard.contents'), callback_data: 'contents' }],
          [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
        ]
      end

      def edit_keyboard
        [
          [
            { text: I18n.t('bot.keyboard.edit'), callback_data: "edit_content-target:token:id:#{content.id}" },
            { text: I18n.t('bot.keyboard.rename'), callback_data: "edit_content-target:name:id:#{content.id}" }
          ]
        ]
      end

      def delete_keyboard
        [{ text: I18n.t('bot.keyboard.delete'), callback_data: "delete_content-id:#{content.id}" }]
      end
    end
  end
end
