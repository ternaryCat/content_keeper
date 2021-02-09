module Telegram
  class ContentReferencesController < ApplicationController
    def callback_query(data)
      action, options = parse_callback_action(data)
      callback_strategy(action.to_sym)&.call(options || {})
    end

    def message(_message)
      action = global_session.dig(:last_action)&.dig(:args)&.first
      return if action.nil? || action != 'add_content'

      content_reference = ContentReferences::Create.call params
      respond_with :message, text: I18n.t('bot.content_reference.added'),
                             reply_markup: { inline_keyboard: added_content_keyboard(content_reference) }
    end

    private

    def callback_strategy(action)
      {
        add_content: ->(_options) { prepare_content_adding },
        cancel_content_adding: ->(_options) { cancel_content_adding },
        content_list: ->(options) { content_list(**options) }
      }[action]
    end

    def parse_callback_action(action)
      action_name, raw_options = action.split('-')
      return [action_name, nil] unless raw_options

      options = Hash[*raw_options.split('_')]
      [action_name, options]
    end

    def prepare_content_adding
      respond_with :message, text: I18n.t('bot.content_reference.add'),
                             reply_markup: { inline_keyboard: add_content_keyboard }
    end

    def cancel_content_adding
      respond_with :message, text: I18n.t('bot.content_reference.canceled_adding'),
                             reply_markup: { inline_keyboard: cancel_adding_content_keyboard }
    end

    def content_list(**options)
      list = ContentReference.where(authentication: current_authentication)
      last_content_id = list.first&.id
      list = list.where('id <= ?', options[:last]) if options[:last]
      list = list.limit(10).order(id: :desc)

      return empty_list_message if list.empty?

      content_list_message(list, last_content_id)
    end

    def empty_list_message
      respond_with :message, text: I18n.t('bot.content_reference.empty_list'),
                             reply_markup: { inline_keyboard: empty_list_message_keyboard }
    end

    def content_list_message(contents, last_content_id)
      respond_with :message,
                   text: I18n.t('bot.content_reference.list'),
                   reply_markup: { inline_keyboard: content_list_message_keyboard(contents, last_content_id) }
    end

    def add_content_keyboard
      [[{ text: I18n.t('bot.keyboard.cancel'), callback_data: 'cancel_content_adding' }]]
    end

    def added_content_keyboard(content)
      [
        [
          { text: I18n.t('bot.keyboard.update_content_name'), callback_data: "update_content_name_#{content.id}" },
          { text: I18n.t('bot.keyboard.destroy_content'), callback_data: "destroy_content_#{content.id}" }
        ],
        [
          { text: I18n.t('bot.keyboard.attach_tag'), callback_data: "attach_tag_#{content.id}" },
          { text: I18n.t('bot.keyboard.content_list'), callback_data: 'content_list' }
        ],
        [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
      ]
    end

    def cancel_adding_content_keyboard
      [[{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]]
    end

    def empty_list_message_keyboard
      [
        [{ text: I18n.t('bot.keyboard.content_list'), callback_data: 'add_content' }],
        [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
      ]
    end

    def content_list_message_keyboard(contents, last_content_id)
      keys = contents.map do |content|
        [{ text: content.name || '...', callback_data: "show_content-id_#{content.id}" }]
      end
      keys.append [{ text: I18n.t('bot.keyboard.next'), callback_data: "content_list-last_#{last_content_id}" }]
      keys
    end

    def params
      { authentication: current_authentication, token: payload['message_id'] }
    end
  end
end
