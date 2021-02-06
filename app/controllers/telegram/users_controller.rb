module Telegram
  class UsersController < ApplicationController
    def start!
      Users::Create.call params

      respond_with :message, text: I18n.t('bot.welcome'), reply_markup: {
        inline_keyboard: inline_keyboard,
        keyboard: keyboard,
        resize_keyboard: true,
        selective: true
      }
    rescue Users::Create::Error
      respond_with :message, text: I18n.t('bot.user.created_error')
    rescue Users::Create::AlreadyExistsError
      respond_with :message, text: I18n.t('bot.user.already_exists'), reply_markup: {
        inline_keyboard: inline_keyboard
      }
    rescue KeyError
      respond_with :message, text: I18n.t('bot.user.authentication_error')
    end

    private

    def inline_keyboard
      [[{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]]
    end

    def keyboard
      [
        [I18n.t('bot.keyboard.help'), I18n.t('bot.keyboard.about')]
      ]
    end

    def params
      from.merge uid: from['id'], provider: :telegram
    end
  end
end
