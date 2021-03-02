module Telegram
  module Feedbacks
    class CreatedAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.feedback.created'),
                                          reply_markup: { inline_keyboard: default_inline_keyboard }
      end
    end
  end
end
