module Telegram
  class UsersController < Telegram::Bot::UpdatesController
    def start!
      Users::Create.call(params)

      respond_with :message, text: I18n.t('bot.welcome')
    rescue Users::Create::Error
      respond_with :message, text: I18n.t('bot.user.created_error')
    rescue Users::Create::AlreadyExistsError
      respond_with :message, text: I18n.t('bot.user.already_exists')
    rescue KeyError
      respond_with :message, text: I18n.t('bot.user.authentication_error')
    end

    private

    def params
      from.merge(uid: from['id'], provider: :telegram)
    end
  end
end
