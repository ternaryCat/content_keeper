module Telegram
  module Feedbacks
    class NewAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.feedback.new'),
                                          reply_markup: { inline_keyboard: default_inline_keyboard }
      end
    end
  end
end
