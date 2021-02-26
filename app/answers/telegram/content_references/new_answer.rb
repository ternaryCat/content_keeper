module Telegram
  module ContentReferences
    class NewAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.content_reference.new'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[button(I18n.t('bot.keyboard.cancel'), 'cancel_content_creating')]]
      end
    end
  end
end
