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

    def debug!
      Webhook::DebugAnswer.render self, current_authentication
    end

    private

    def callback_strategy(action)
      {
        help: -> { help },
        about: -> { about }
      }[action]
    end

    def message_strategy(message)
      {
        I18n.t('bot.keyboard.help') => -> { help },
        I18n.t('bot.keyboard.about') => -> { about }
      }[message]
    end

    def help
      Webhook::HelpAnswer.render self
    end

    def about
      Webhook::AboutAnswer.render self
    end
  end
end
