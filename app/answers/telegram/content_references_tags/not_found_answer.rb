module Telegram
  module ContentReferencesTags
    class NotFoundAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.content_references_tag.not_found'),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[button(I18n.t('bot.keyboard.contents'), 'contents')], [button(I18n.t('bot.keyboard.help'), 'help')]]
      end
    end
  end
end
