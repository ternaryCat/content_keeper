module Telegram
  module ContentReferences
    class CanceledCreatingAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.content_reference.canceled_creating'),
                                          reply_markup: { inline_keyboard: default_inline_keyboard }
      end
    end
  end
end
