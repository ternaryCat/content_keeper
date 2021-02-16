module Telegram
  module Tags
    class CanceledUpdatingAnswer < BaseAnswer
      option :target

      def render
        controller.respond_with :message, text: I18n.t("bot.tag.canceled_updating_#{target}"),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]]
      end
    end
  end
end