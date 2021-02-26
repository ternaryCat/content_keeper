module Telegram
  module ContentReferences
    class EditAnswer < BaseAnswer
      option :target

      def render
        super
        controller.respond_with :message, text: I18n.t("bot.content_reference.edit_#{target}"),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[button(I18n.t('bot.keyboard.cancel'), 'cancel_content_updating', target: target)]]
      end
    end
  end
end
