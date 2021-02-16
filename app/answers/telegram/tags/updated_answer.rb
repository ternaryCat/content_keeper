module Telegram
  module Tags
    class UpdatedAnswer < BaseAnswer
      param :tag
      option :target

      def render
        controller.respond_with :message, text: I18n.t("bot.tag.updated_#{target}"),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [{ text: I18n.t('bot.keyboard.show'), callback_data: "show_tag-id:#{tag.id}" }],
          [{ text: I18n.t('bot.keyboard.tags'), callback_data: 'tags' }],
          [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
        ]
      end
    end
  end
end