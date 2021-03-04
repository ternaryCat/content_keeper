module Telegram
  module Tags
    class ExceedingLimitAnswer < BaseAnswer
      def render
        answer I18n.t('bot.exceeding_limit'), { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [button(I18n.t('bot.keyboard.plans'), 'plans')],
          *default_inline_keyboard
        ]
      end
    end
  end
end
