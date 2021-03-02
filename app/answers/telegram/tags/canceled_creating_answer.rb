module Telegram
  module Tags
    class CanceledCreatingAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.tag.canceled_creating'),
                                          reply_markup: { inline_keyboard: default_inline_keyboard }
      end
    end
  end
end
