module Telegram
  module Tags
    class UpdatedAnswer < BaseAnswer
      param :tag
      option :target

      def render
        controller.respond_with :message, text: I18n.t("bot.tag.updated_#{target}"),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [button(I18n.t('bot.keyboard.show'), 'show_tag', id: tag.id)],
          [button(I18n.t('bot.keyboard.tags'), 'tags')],
          [button(I18n.t('bot.keyboard.help'), 'help')]
        ]
      end
    end
  end
end
