module Telegram
  module Users
    class ActivatedPlanAnswer < BaseAnswer
      def render
        super
        answer I18n.t('bot.plans.activating_not_available'),
               { inline_keyboard: inline_keyboard },
               %i(text reply_markup)
      end

      private

      def inline_keyboard
        [
          [
            button(I18n.t('bot.plans.keyboard.back'), 'plans', mode: :edit),
            button(I18n.t('bot.keyboard.feedback'), 'feedback')
          ],
          *default_inline_keyboard
        ]
      end
    end
  end
end
