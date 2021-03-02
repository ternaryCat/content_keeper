module Telegram
  module Tags
    class IndexAnswer < BaseAnswer
      param :tags
      param :count
      option :content_id, optional: true
      option :next_page_id, optional: true
      option :previous_page_id, optional: true

      def render
        super
        return empty_list_response if count.zero?
        return one_page_list_response if !next_page_id && !previous_page_id

        multi_page_list_response
      end

      private

      def empty_list_response
        controller.respond_with :message, text: I18n.t('bot.tag.empty_list'),
                                          reply_markup: { inline_keyboard: empty_list_keyboard }
      end

      def one_page_list_response
        controller.respond_with :message, text: I18n.t('bot.tag.one_page_list'),
                                          reply_markup: { inline_keyboard: one_page_keyboard }
      end

      def multi_page_list_response
        answer I18n.t('bot.tag.multi_page_list', count: count),
               { inline_keyboard: multi_page_list_keyboard },
               :reply_markup
      end

      def empty_list_keyboard
        [[button(I18n.t('bot.keyboard.new_tag'), 'new_tag', content_id: content_id)], *default_inline_keyboard]
      end

      def one_page_keyboard
        [*tags_keyboard, [close_button]]
      end

      def multi_page_list_keyboard
        [
          *tags_keyboard,
          *arrows_keyboard,
          [close_button]
        ]
      end

      def arrows_keyboard
        result = []
        if previous_page_id
          result.append button(I18n.t('bot.keyboard.previous'), 'tags', mode: :edit,
                                                                        max_id: previous_page_id,
                                                                        content_id: content_id)
        end

        if next_page_id
          result.append button(I18n.t('bot.keyboard.next'), 'tags', mode: :edit,
                                                                    max_id: next_page_id,
                                                                    content_id: content_id)
        end

        [result]
      end

      def tags_keyboard
        tags.map { |tag| [button(tag.name, 'show_tag', id: tag.id)] }
      end
    end
  end
end
