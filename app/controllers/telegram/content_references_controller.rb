module Telegram
  class ContentReferencesController < ApplicationController
    def callback_query(data)
      action, options = parse_action(data)
      callback_strategy(action.to_sym)&.call(options)
    rescue ::ContentReferences::BaseService::NotFound
      ContentReferences::NotFoundAnswer.render self
    end

    def message(message)
      action = global_session[:last_action]&.dig(:args)&.first
      return unless action
      return if global_session[:last_action][:action] != 'callback_query'

      action_name, options = parse_action(action)
      last_action_strategy(action_name.to_sym)&.call(options, message)
    end

    private

    def callback_strategy(action)
      {
        new_content: ->(_options) { ContentReferences::NewAnswer.render self },
        cancel_content_creating: ->(_options) { ContentReferences::CanceledCreatingAnswer.render self },
        edit_content: ->(options) { ContentReferences::EditAnswer.render self, **options },
        cancel_content_updating: ->(options) { ContentReferences::CanceledUpdatingAnswer.render self, **options },
        contents: ->(options) { content_list(options) },
        show_content: ->(options) { show_content(options) },
        delete_content: ->(options) { delete_content(options) },
        cancel_deleting_content: ->(_options) { ContentReferences::CanceledDeletingAnswer.render self },
        destroy_content: ->(options) { destroy_content(options) }
      }[action]
    end

    def last_action_strategy(action)
      {
        new_content: ->(_options, message) { create_content(message) },
        edit_content: ->(options, message) { edit_content(options, message) }
      }[action]
    end

    def create_content(message)
      name = message['text']&.slice(..10) || message.keys.last
      content_reference = ::ContentReferences::Create.call params.merge(name: name)
      ContentReferences::CreatedAnswer.render self, content_reference
    end

    def edit_content(options, message)
      content_reference = ContentReference.find_by id: options[:id]
      params = { token: message['message_id'], name: message['text'] }

      ::ContentReferences::Update.call content_reference, params.slice(options[:target].to_sym)
      ContentReferences::UpdatedAnswer.render self, content_reference, options
    end

    def parse_action(action)
      action_name, raw_options = action.split('-')
      return [action_name, {}] unless raw_options

      options = Hash[*raw_options.split(':')]
      [action_name, options.symbolize_keys]
    end

    def content_list(options = {})
      user_contents = ContentReference.where(authentication: current_authentication)
      contents_count = user_contents.count
      contents = user_contents
      contents = contents.where('id <= ?', options[:previous]) if options[:previous]
      contents = contents.where('id >= ?', options[:next]) if options[:next]
      contents = contents.limit(5).order(id: :desc)
      previous_id = user_contents.where('id < ?', contents.last&.id).order(id: :desc).limit(1).first&.id
      next_id = user_contents.where('id > ?', contents.first&.id).order(id: :asc).limit(1).first&.id

      ContentReferences::IndexAnswer.render self, contents, contents_count, previous_id: previous_id, next_id: next_id
    end

    def show_content(options = {})
      content = ContentReference.find_by(id: options[:id])
      ContentReferences::ShowAnswer.render self, current_authentication, content
    end

    def delete_content(options = {})
      content = ContentReference.find_by id: options[:id]
      ContentReferences::DeleteAnswer.render self, content
    end

    def destroy_content(options = {})
      content = ContentReference.find_by id: options[:id]
      ::ContentReferences::Destroy.call content
      ContentReferences::DeletedAnswer.render self
    end

    def params
      { authentication: current_authentication, token: payload['message_id'] }
    end
  end
end
