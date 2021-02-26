module Telegram
  module Tags
    class NotFoundAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.tag.not_found'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[button(I18n.t('bot.keyboard.tags'), 'tags')], [button(I18n.t('bot.keyboard.help'), 'help')]]
      end
    end
  end
end
