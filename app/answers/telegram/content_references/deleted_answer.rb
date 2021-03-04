module Telegram
  module ContentReferences
    class DeletedAnswer < BaseAnswer
      def render
        super
        answer I18n.t('bot.content_reference.deleted'),
               { inline_keyboard: inline_keyboard },
               %i(text reply_markup)
      end

      private

      def inline_keyboard
        [
          [
            button(I18n.t('bot.keyboard.new_content'), 'new_content'),
            button(I18n.t('bot.keyboard.contents'), 'contents')
          ],
          *default_inline_keyboard
        ]
      end
    end
  end
end
