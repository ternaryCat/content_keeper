module Telegram
  module Tags
    class DuplicateAnswer < BaseAnswer
      def render
        answer I18n.t('bot.tag.duplicate'), { inline_keyboard: default_inline_keyboard }
      end
    end
  end
end
