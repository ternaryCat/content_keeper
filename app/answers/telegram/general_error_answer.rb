module Telegram
  class GeneralErrorAnswer < BaseAnswer
    def render
      answer I18n.t('bot.error'), { inline_keyboard: error_keyboard }
    end

    private

    def error_keyboard
      [[button(I18n.t('bot.keyboard.feedback'), 'feedback'), close_button]]
    end
  end
end
