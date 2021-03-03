module Telegram
  module Tags
    class EditAnswer < BaseAnswer
      option :target

      def render
        super
        controller.respond_with :message, text: I18n.t("bot.tag.edit_#{target}"),
                                          reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[button(I18n.t('bot.keyboard.cancel'), 'cancel_tag_updating', target: target, mode: :edit)]]
      end
    end
  end
end
