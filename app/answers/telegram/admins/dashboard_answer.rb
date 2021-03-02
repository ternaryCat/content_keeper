module Telegram
  module Admins
    class DashboardAnswer < BaseAnswer
      param :users_count
      param :contents_count
      param :new_users_count
      param :new_contents_count

      def render
        super
        controller.respond_with :message, text: text, reply_markup: { inline_keyboard: inline_keyboard }
      end

      private

      def text
        I18n.t('bot.dashboard.summary', users_count: users_count,
                                        contents_count: contents_count,
                                        new_users_count: new_users_count,
                                        new_contents_count: new_contents_count)
      end

      def inline_keyboard
        [[button(I18n.t('bot.keyboard.close'), 'close')]]
      end
    end
  end
end
