module Telegram
  module Tags
    class ShowAnswer < BaseAnswer
      param :tag

      def render
        controller.respond_with :message, text: tag.name, reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [
            { text: I18n.t('bot.keyboard.rename'), callback_data: "edit_tag-target:name:id:#{tag.id}" },
            { text: I18n.t('bot.keyboard.delete'), callback_data: "delete_tag-id:#{tag.id}" }
          ],
          [{ text: I18n.t("bot.tag.keyboard.contents"), callback_data: "contents-tag_id:#{tag.id}" }],
          [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
        ]
      end
    end
  end
end
