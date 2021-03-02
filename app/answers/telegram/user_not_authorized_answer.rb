module Telegram
  class UserNotAuthorizedAnswer < BaseAnswer
    def render
      controller.respond_with :message, text: I18n.t('bot.user_not_authorized'),
                                        reply_markup: { inline_keyboard: inline_keyboard }
    end

    private

    def inline_keyboard
      [[button(I18n.t('bot.keyboard.help'), 'help')]]
    end
  end
end
