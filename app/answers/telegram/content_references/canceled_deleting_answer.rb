module Telegram
  module ContentReferences
    class CanceledDeletingAnswer < BaseAnswer
      def render
        super
        answer I18n.t('bot.content_reference.canceled_deleting'),
               { inline_keyboard: default_inline_keyboard },
               %i(text reply_markup)
      end
    end
  end
end
