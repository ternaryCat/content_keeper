module Telegram
  class WebhookController < ApplicationController
    def self.dispatch(bot, update)
      controllers = Telegram.constants.select { |x| x.to_s.include?('Controller') && x.to_s != name.demodulize }
      controllers.each do |controller|
        Object.const_get("Telegram::#{controller}").dispatch(bot, update)
      end

      super
    end

    def process(action, *args)
      super
      store_data
      global_session[:last_action] = { action: action, args: args }
    end

    def callback_query(data)
      callback_strategy(data.to_sym)&.call
    end

    def message(message)
      message_strategy(message['text'])&.call
    end

    def help!
      help
    end

    def about!
      about
    end

    private

    def callback_strategy(action)
      {
        help: -> { help },
        about: -> { about },
        close: -> { Webhook::CloseAnswer.render self, from['id'], payload['message']['message_id'] }
      }[action]
    end

    def message_strategy(message)
      {
        I18n.t('bot.keyboard.help') => -> { help },
        I18n.t('bot.keyboard.about') => -> { about }
      }[message]
    end

    def help
      Webhook::HelpAnswer.render self, current_user
    end

    def about
      Webhook::AboutAnswer.render self
    end

    def store_data
      Metric.create title: 'action',
                    user: current_user,
                    data: { current: payload.except('id', 'from'), last: global_session[:last_action] }
    end
  end
end
