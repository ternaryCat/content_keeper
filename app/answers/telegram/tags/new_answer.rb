module Telegram
  module Tags
    class NewAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.tag.new'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[button(I18n.t('bot.keyboard.cancel'), 'cancel_tag_creating', mode: :edit)]]
      end
    end
  end
end
