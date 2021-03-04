module Telegram
  module Tags
    class DeletedAnswer < BaseAnswer
      def render
        super
        answer I18n.t('bot.tag.deleted'), { inline_keyboard: inline_keyboard }, %i(text reply_markup)
      end

      private

      def inline_keyboard
        [
          [button(I18n.t('bot.keyboard.new_tag'), 'new_tag'), button(I18n.t('bot.keyboard.tags'), 'tags')],
          *default_inline_keyboard
        ]
      end
    end
  end
end
