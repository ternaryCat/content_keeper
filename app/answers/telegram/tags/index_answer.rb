module Telegram
  module Tags
    class IndexAnswer < BaseAnswer
      param :tags
      param :count
      option :previous_id, optional: true
      option :next_id, optional: true
      option :mode, optional: true

      def render
        return empty_list_response if count.zero?
        return one_page_list_response if !previous_id && !next_id

        multi_page_list_response
      end

      private

      def empty_list_response
        controller.respond_with :message, text: I18n.t('bot.tag.empty_list'),
                                          reply_markup: { inline_keyboard: empty_list_keyboard }
      end

      def one_page_list_response
        controller.respond_with :message, text: I18n.t('bot.tag.one_page_list'),
                                          reply_markup: { inline_keyboard: tags_keyboard }
      end

      def multi_page_list_response
        if mode == 'edit'
          return controller.edit_message :reply_markup, reply_markup: { inline_keyboard: multi_page_list_keyboard }
        end

        controller.respond_with :message, text: I18n.t('bot.tag.multi_page_list', count: count),
                                          reply_markup: { inline_keyboard: multi_page_list_keyboard }
      rescue RuntimeError
        controller.respond_with :message, text: I18n.t('bot.tag.multi_page_list', count: count),
                                          reply_markup: { inline_keyboard: multi_page_list_keyboard }
      end

      def empty_list_keyboard
        [
          [{ text: I18n.t('bot.keyboard.new_tag'), callback_data: 'new_tag' }],
          [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
        ]
      end

      def multi_page_list_keyboard
        [
          *tags_keyboard,
          *arrows_keyboard
        ]
      end

      def arrows_keyboard
        result = []
        if previous_id
          result += [
            [{ text: I18n.t('bot.keyboard.previous'), callback_data: "tags-mode:edit:previous_id:#{previous_id}" }]
          ]
        end

        if next_id
          result += [[{ text: I18n.t('bot.keyboard.next'), callback_data: "tags-mode:edit:next_id:#{next_id}" }]]
        end

        result
      end

      def tags_keyboard
        tags.map { |tag| [{ text: tag.name, callback_data: "show_tag-id:#{tag.id}" }] }
      end
    end
  end
end
