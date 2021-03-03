module Telegram
  module Tags
    class CanceledCreatingAnswer < BaseAnswer
      def render
        super
        answer I18n.t('bot.tag.canceled_creating'), { inline_keyboard: default_inline_keyboard }, %i(text reply_markup)
      end
    end
  end
end
