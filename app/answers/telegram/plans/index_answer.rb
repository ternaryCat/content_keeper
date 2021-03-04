module Telegram
  module Plans
    class IndexAnswer < BaseAnswer
      def render
        super
        answer I18n.t('bot.plans.choose', plan_type: current_user.plan_type),
               { inline_keyboard: inline_keyboard },
               %i(text reply_markup)
      end

      private

      def inline_keyboard
        plans_buttons = PLANS_TITLES.map { |plan| [button(plan, 'plan', plan_type: plan, mode: :edit)] }
        [*plans_buttons, [close_button]]
      end
    end
  end
end
