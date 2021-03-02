module Feedbacks
  class Reply < BaseService
    class Error < RuntimeError; end

    param :feedback
    option :answer

    def call
      raise Error if answer.empty?
      raise Error unless feedback.update answer: answer, state: :closed

      Telegram.bot.send_message chat_id: feedback.authentication.uid,
                                text: message,
                                reply_markup: { inline_keyboard: default_inline_keyboard },
                                parse_mode: :markdown
    end

    private

    def message
      "#{I18n.t('bot.feedback.answer')}\n#{feedback.text}\n#{'=' * 20}\n#{answer}"
    end
  end
end
