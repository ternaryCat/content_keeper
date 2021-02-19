module Telegram
  module ContentReferences
    class EditAnswer < BaseAnswer
      option :target

      def render
        controller.respond_with :message, text: I18n.t("bot.content_reference.edit_#{target}"),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[{ text: I18n.t('bot.keyboard.cancel'), callback_data: "cancel_content_updating-target:#{target}" }]]
      end
    end
  end
end
