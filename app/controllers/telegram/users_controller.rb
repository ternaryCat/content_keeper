module Telegram
  class UsersController < ApplicationController
    def start!
      ::Users::Create.call params

      Users::StartAnswer.render self
    rescue ::Users::Create::AlreadyExistsError
      Users::StartAlreadyExistsAnswer.render self
    rescue ::Users::Create::Error, KeyError
      Users::StartErrorAnswer.render self
    end

    def callback_query(data)
      action, options = parse_action(data)
      callback_strategy(action.to_sym)&.call(options)
    end

    private

    def callback_strategy(action)
      {
        activate_plan: ->(options) { activate_plan(options) }
      }[action]
    end

    def activate_plan(options)
      ::Users::ActivatePlan.call current_user, options[:plan_type]
      Users::ActivatedPlanAnswer.render self, options
    rescue ::Users::ActivatePlan::Error
      GeneralErrorAnswer.render self, options
    end

    def params
      from.merge uid: from['id'], provider: :telegram
    end
  end
end
