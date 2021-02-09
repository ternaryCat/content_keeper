module Telegram
  class WebhookController < ApplicationController
    def self.dispatch(bot, update)
      controllers = Telegram.constants.select { |x| x.to_s.include?('Controller') && x.to_s != name.demodulize }
      controllers.each do |controller|
        Object.const_get('Telegram::' + controller.to_s).dispatch(bot, update)
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
      respond_with :message, text: I18n.t('bot.help'), reply_markup: { inline_keyboard: help_keyboard }
    end

    def about
      respond_with :message, text: I18n.t('bot.about'), reply_markup: { inline_keyboard: about_keyboard }
    end

    def help_keyboard
      [
        [{ text: I18n.t('bot.keyboard.add_content'), callback_data: 'add_content' }],
        [
          { text: I18n.t('bot.keyboard.find_content'), callback_data: 'find_content' },
          { text: I18n.t('bot.keyboard.content_list'), callback_data: 'content_list' }
        ],
        [
          { text: I18n.t('bot.keyboard.create_tag'), callback_data: 'create_tag' },
          { text: I18n.t('bot.keyboard.list_tags'), callback_data: 'list_tags' }
        ]
      ]
    end

    def about_keyboard
      [[{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]]
    end
  end
end
