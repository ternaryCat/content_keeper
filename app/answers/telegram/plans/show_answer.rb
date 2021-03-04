module Telegram
  module Plans
    class ShowAnswer < BaseAnswer
      option :plan_type

      def render
        super
        answer text, { inline_keyboard: inline_keyboard }, %i(text reply_markup)
      end

      private

      def text
        I18n.t 'bot.plans.summary', plan_type: plan_type,
                                    max_contents: plan.contents,
                                    max_tags: plan.tags,
                                    cost: plan.cost
      end

      def plan
        PLANS[plan_type]
      end

      def inline_keyboard
        result = []
        if current_user.plan_type != plan_type
          result.append [button(I18n.t('bot.plans.keyboard.buy'), 'activate_plan', plan_type: plan_type, mode: :edit)]
        end

        [*result, [button(I18n.t('bot.plans.keyboard.back'), 'plans', mode: :edit), close_button]]
      end
    end
  end
end
