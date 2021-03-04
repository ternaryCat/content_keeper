module Telegram
  class TagsEditController < ApplicationController
    def callback_query(data)
      action, options = parse_action(data)
      callback_strategy(action.to_sym)&.call(options)
    rescue ::Tags::BaseService::NotFound
      Tags::NotFoundAnswer.render self
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
        destroy_tag: ->(options) { destroy_tag(options) }
      }[action]
    end

    def last_action_strategy(action)
      {
        new_tag: ->(options, message) { create_tag(options, message) },
        edit_tag: ->(options, message) { edit_tag(options, message) }
      }[action]
    end

    def create_tag(options, message)
      tag = ::Tags::Create.call params(message)
      Tags::CreatedAnswer.render self, tag, options
      attach_content(tag, options) if options[:content_id]
    rescue ::ContentReferencesTags::BaseService::NotFoundContent
      ContentReferences::NotFoundAnswer.render self
    rescue ::ContentReferencesTags::BaseService::NotFoundTag
      Tags::NotFoundAnswer.render self
    rescue ::ContentReferencesTags::BaseService::Duplicate
      ContentReferencesTags::DuplicateAnswer.render self, content
    rescue ::Tags::BaseService::Duplicate
      Tags::DuplicateAnswer.render self
    rescue ::Tags::BaseService::ExceedingLimit
      Tags::ExceedingLimitAnswer.render self
    end

    def edit_tag(options, message)
      tag = Tag.find_by id: options[:id]

      ::Tags::Update.call tag, params(message).slice(:user, options[:target].to_sym)
      Tags::UpdatedAnswer.render self, tag, options
    end

    def destroy_tag(options = {})
      tag = Tag.find_by id: options[:id]
      ::Tags::Destroy.call tag
      Tags::DeletedAnswer.render self, options
    end

    def attach_content(tag, options)
      content = ContentReference.find_by(id: options[:content_id])
      ::ContentReferencesTags::Attach.call content, tag
      ContentReferencesTags::AttachedAnswer.render self, content, tag
    end

    def params(message)
      { user: current_user, name: message['text'] }
    end
  end
end
