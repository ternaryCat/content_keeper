module Telegram
  module Tags
    class NewAnswer < BaseAnswer
      def render
        controller.respond_with :message, text: I18n.t('bot.tag.new'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[{ text: I18n.t('bot.keyboard.cancel'), callback_data: 'cancel_tag_creating' }]]
      end
    end
  end
end