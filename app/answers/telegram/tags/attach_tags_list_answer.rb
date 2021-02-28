module Telegram
  module Tags
    class AttachTagsListAnswer < BaseAnswer
      param :tags
      param :count
      option :content_id
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
        controller.respond_with :message, text: I18n.t('bot.tag.choose'),
                                          reply_markup: { inline_keyboard: tags_keyboard }
      end

      def multi_page_list_response
        answer I18n.t('bot.tag.choose', count: count),
               { inline_keyboard: multi_page_list_keyboard },
               :reply_markup
      end

      def empty_list_keyboard
        [
          [button(I18n.t('bot.keyboard.new_tag'), 'new_tag', content_id: content_id)],
          [button(I18n.t('bot.keyboard.help'), 'help'), button(I18n.t('bot.keyboard.close'), 'close')]
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
        result.append(previous_arrow) if previous_page_id
        result.append(next_arrow) if next_page_id
        return [] if result.empty?

        [result]
      end

      def previous_arrow
        button I18n.t('bot.keyboard.previous'), 'attach_tags_list', mode: :edit,
                                                                    max_id: previous_page_id,
                                                                    content_id: content_id
      end

      def next_arrow
        button I18n.t('bot.keyboard.next'), 'attach_tags_list', mode: :edit,
                                                                max_id: next_page_id,
                                                                content_id: content_id
      end

      def tags_keyboard
        tags.map { |tag| [button(tag.name, 'attach_tag', id: tag.id, content_id: content_id)] }
      end
    end
  end
end
