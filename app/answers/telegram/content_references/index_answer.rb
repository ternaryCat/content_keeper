module Telegram
  module ContentReferences
    class IndexAnswer < BaseAnswer
      param :contents
      param :count
      option :tag_id, optional: true
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
        controller.respond_with :message, text: I18n.t('bot.content_reference.empty_list'),
                                          reply_markup: { inline_keyboard: empty_list_keyboard }
      end

      def one_page_list_response
        controller.respond_with :message, text: I18n.t('bot.content_reference.one_page_list'),
                                          reply_markup: { inline_keyboard: one_page_keyboard }
      end

      def multi_page_list_response
        answer I18n.t('bot.content_reference.multi_page_list', count: count),
               { inline_keyboard: multi_page_list_keyboard },
               %i[reply_markup]
      end

      def empty_list_keyboard
        [[button(I18n.t('bot.keyboard.new_content'), 'new_content'), close_button]]
      end

      def one_page_keyboard
        [*contents_keyboard, [close_button]]
      end

      def multi_page_list_keyboard
        [
          *contents_keyboard,
          *arrows_keyboard,
          [close_button]
        ]
      end

      def arrows_keyboard
        result = []
        if previous_page_id
          result.append button(I18n.t('bot.keyboard.previous'), 'contents', mode: :edit,
                                                                            max_id: previous_page_id,
                                                                            tag_id: tag_id)
        end

        if next_page_id
          result.append button(I18n.t('bot.keyboard.next'), 'contents', mode: :edit,
                                                                        max_id: next_page_id,
                                                                        tag_id: tag_id)
        end

        return [] if result.empty?

        [result]
      end

      def contents_keyboard
        contents.map { |content| [button(content.name || '...', 'show_content', id: content.id)] }
      end
    end
  end
end
