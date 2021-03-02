module Telegram
  module ContentReferences
    class CanceledDeletingAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.content_reference.canceled_deleting'),
                                          reply_markup: { inline_keyboard: default_inline_keyboard }
      end
    end
  end
end
