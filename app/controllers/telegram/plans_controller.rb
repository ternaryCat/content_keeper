module Telegram
  class PlansController < ApplicationController
    def callback_query(data)
      action, options = parse_action(data)
      callback_strategy(action.to_sym)&.call(options)
    end

    private

    def callback_strategy(action)
      {
        plans: ->(options) { Plans::IndexAnswer.render self, options },
        plan: ->(options) { Plans::ShowAnswer.render self, options }
      }[action]
    end
  end
end
