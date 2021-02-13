module Telegram
  module ContentReferences
    class IndexAnswer < BaseAnswer
      param :contents
      param :count
      option :previous_id, optional: true
      option :next_id, optional: true

      def render
        return empty_list_response if count.zero?
        return one_page_list_response if !previous_id && !next_id

        multi_page_list_response
      end

      private

      def empty_list_response
        controller.respond_with :message, text: I18n.t('bot.content_reference.empty_list'),
                                          reply_markup: { inline_keyboard: empty_list_keyboard }
      end

      def one_page_list_response
        controller.respond_with :message, text: I18n.t('bot.content_reference.one_page_list'),
                                          reply_markup: { inline_keyboard: contents_keyboard }
      end

      def multi_page_list_response
        controller.edit_message :reply_markup, reply_markup: { inline_keyboard: multi_page_list_keyboard }
      rescue RuntimeError
        controller.respond_with :message, text: I18n.t('bot.content_reference.multi_page_list', count: count),
                                          reply_markup: { inline_keyboard: multi_page_list_keyboard }
      end

      def empty_list_keyboard
        [
          [{ text: I18n.t('bot.keyboard.new_content'), callback_data: 'new_content' }],
          [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
        ]
      end

      def multi_page_list_keyboard
        [
          *contents_keyboard,
          *arrows_keyboard
        ]
      end

      def arrows_keyboard
        result = []
        if previous_id
          result += [[{ text: I18n.t('bot.keyboard.previous'), callback_data: "contents-previous:#{previous_id}" }]]
        end
        result += [[{ text: I18n.t('bot.keyboard.next'), callback_data: "contents-next:#{next_id}" }]] if next_id

        result
      end

      def contents_keyboard
        contents.map { |content| [{ text: content.name || '...', callback_data: "show_content-id:#{content.id}" }] }
      end
    end
  end
end
