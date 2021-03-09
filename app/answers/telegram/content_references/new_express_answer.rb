module Telegram
  module ContentReferences
    class NewExpressAnswer < BaseAnswer
      param :message_id
      param :name

      def render
        super
        answer I18n.t('bot.content_reference.new_express'), { inline_keyboard: inline_keyboard }
      end

      private

      def inline_keyboard
        [[save_button, close_button]]
      end

      def save_button
        button(I18n.t('bot.content_reference.keyboard.save'), 'create_content', token: message_id,
                                                                                name: name,
                                                                                mode: :edit)
      end
    end
  end
end
