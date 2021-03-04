module Telegram
  module ContentReferences
    class DeleteAnswer < BaseAnswer
      param :content

      def render
        super
        if content
          return controller.respond_with :message, text: I18n.t('bot.content_reference.delete'),
                                                   reply_markup: { inline_keyboard: inline_keyboard }
        end

        answer I18n.t('bot.content_reference.not_found'),
               { inline_keyboard: default_inline_keyboard },
               %i(text reply_markup)
      end

      private

      def inline_keyboard
        [[
          button(I18n.t('bot.keyboard.cancel'), 'cancel_deleting_content', id: content.id, mode: :edit),
          button(I18n.t('bot.keyboard.delete'), 'destroy_content', id: content.id, mode: :edit)
        ]]
      end
    end
  end
end
