module Telegram
  module ContentReferences
    class UpdatedAnswer < BaseAnswer
      param :content
      option :target

      def render
        super
        controller.respond_with :message, text: I18n.t("bot.content_reference.updated_#{target}"),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [button(I18n.t('bot.keyboard.show'), 'show_content', id: content.id)],
          [button(I18n.t('bot.keyboard.contents'), 'contents')],
          [button(I18n.t('bot.keyboard.help'), 'help')]
        ]
      end
    end
  end
end
