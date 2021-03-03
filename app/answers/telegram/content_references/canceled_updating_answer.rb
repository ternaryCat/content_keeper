module Telegram
  module ContentReferences
    class CanceledUpdatingAnswer < BaseAnswer
      option :target

      def render
        super
        answer I18n.t("bot.content_reference.canceled_updating_#{target}"),
               { inline_keyboard: default_inline_keyboard },
               %i(text reply_markup)
      end
    end
  end
end
