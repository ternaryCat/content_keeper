module Telegram
  module ContentReferences
    class CanceledCreatingAnswer < BaseAnswer
      def render
        super
        answer I18n.t('bot.content_reference.canceled_creating'),
               { inline_keyboard: default_inline_keyboard },
               %i(text reply_markup)
      end
    end
  end
end
