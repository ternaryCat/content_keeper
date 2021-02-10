module Telegram
  module ContentReferences
    class UpdatedAnswer < BaseAnswer
      param :content
      option :target

      def render
        controller.respond_with :message, text: I18n.t("bot.content_reference.updated_#{target}"),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [{ text: I18n.t('bot.keyboard.contents'), callback_data: 'contents' }],
          [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
        ]
      end
    end
  end
end
