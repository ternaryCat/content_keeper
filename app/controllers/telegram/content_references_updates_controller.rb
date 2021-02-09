module Telegram
  class ContentReferencesUpdatesController < ApplicationController
    def callback_query(action)
      action_name, _content_id = parse_action(action)
      callback_strategy(action_name)&.call
    end

    def message(message)
      action = global_session.dig(:last_action)&.dig(:args)&.first
      return unless action

      action_name, content_id = parse_action(action)
      return if action_name != :update_content_name

      content_reference = ContentReference.find_by id: content_id
      ContentReferences::Update.call content_reference, name: message['text']
      respond_with :message, text: I18n.t('bot.content_reference.name_updated'),
                             reply_markup: { inline_keyboard: content_name_updated_keyboard }
    end

    private

    def parse_action(action)
      parts = action.split('_')
      name = parts.slice(0..-2).join('_').to_sym
      [name, parts.last]
    end

    def callback_strategy(action)
      {
        update_content_name: -> { update_content_name },
        destroy_content: -> { destroy_content },
        cancel_content_name_updating: -> { cancel_content_name_updating }
      }[action]
    end

    def update_content_name
      respond_with :message, text: I18n.t('bot.content_reference.update_content_name'),
                             reply_markup: { inline_keyboard: update_name_keyboard }
    end

    def cancel_content_name_updating
      respond_with :message, text: I18n.t('bot.content_reference.canceled_content_name_updating'),
                             reply_markup: { inline_keyboard: canceled_content_name_updating_keyboard }
    end

    def update_name_keyboard
      [[{ text: I18n.t('bot.keyboard.cancel'), callback_data: 'cancel_content_name_updating' }]]
    end

    def canceled_content_name_updating_keyboard
      [[{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]]
    end

    def content_name_updated_keyboard
      [
        [{ text: I18n.t('bot.keyboard.content_list'), callback_data: 'content_list' }],
        [{ text: I18n.t('bot.keyboard.help'), callback_data: 'help' }]
      ]
    end
  end
end
