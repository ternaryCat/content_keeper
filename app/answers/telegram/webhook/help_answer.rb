module Telegram
  module Webhook
    class HelpAnswer < BaseAnswer
      def render
        super
        controller.respond_with :message, text: I18n.t('bot.help'),
                                          reply_markup: { keyboard: keyboard, resize_keyboard: true }
        controller.respond_with :message, text: I18n.t('bot.menu'), reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [
          [
            button(I18n.t('bot.keyboard.new_content'), 'new_content'),
            button(I18n.t('bot.keyboard.contents'), 'contents')
          ],
          [button(I18n.t('bot.keyboard.new_tag'), 'new_tag'), button(I18n.t('bot.keyboard.tags'), 'tags')],
          [button(I18n.t('bot.keyboard.close'), 'close')]
        ]
      end

      def keyboard
        [[I18n.t('bot.keyboard.help'), I18n.t('bot.keyboard.about')]]
      end
    end
  end
end
