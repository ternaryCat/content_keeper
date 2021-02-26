module Telegram
  module ContentReferences
    class CanceledCreatingAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.content_reference.canceled_creating'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[button(I18n.t('bot.keyboard.help'), 'help')]]
      end
    end
  end
end
