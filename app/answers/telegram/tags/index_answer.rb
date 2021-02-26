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
          [button(I18n.t('bot.keyboard.new_tag'), 'new_tag')],
          [button(I18n.t('bot.keyboard.help'), 'help')],
          [button(I18n.t('bot.keyboard.close'), 'close')]
        ]
      end

      def one_page_keyboard
        [*tags_keyboard, [button(I18n.t('bot.keyboard.close'), 'close')]]
      end

      def multi_page_list_keyboard
        [
          *tags_keyboard,
          *arrows_keyboard,
          [button(I18n.t('bot.keyboard.close'), 'close')]
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

        [] if result.empty?
        [result]
      end

      def tags_keyboard
        tags.map { |tag| [button(tag.name, 'show_tag', id: tag.id)] }
      end
    end
  end
end
