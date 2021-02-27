module Telegram
  class TagsController < ApplicationController
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
        new_tag: ->(_options) { Tags::NewAnswer.render self },
        cancel_tag_creating: ->(_options) { Tags::CanceledCreatingAnswer.render self },
        edit_tag: ->(options) { Tags::EditAnswer.render self, **options },
        cancel_tag_updating: ->(options) { Tags::CanceledUpdatingAnswer.render self, **options },
        tags: ->(options) { tags_list(options) },
        show_tag: ->(options) { show_tag(options) },
        delete_tag: ->(options) { delete_tag(options) },
        cancel_deleting_tag: ->(_options) { Tags::CanceledDeletingAnswer.render self },
        destroy_tag: ->(options) { destroy_tag(options) },
        attach_tags_list: ->(options) { attach_tags_list(options) },
        detach_tags_list: ->(options) { detach_tags_list(options) }
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
      Tags::CreatedAnswer.render self, tag
      return unless options[:content_id]

      content = ContentReference.find_by(id: options[:content_id])
      ::ContentReferencesTags::Attach.call content, tag
      ContentReferencesTags::AttachedAnswer.render self, content, tag
    rescue ::ContentReferencesTags::BaseService::NotFoundContent
      ContentReferences::NotFoundAnswer.render self
    rescue ::ContentReferencesTags::BaseService::NotFoundTag
      Tags::NotFoundAnswer.render self
    rescue ::ContentReferencesTags::BaseService::Duplicate
      ContentReferencesTags::DuplicateAnswer.render self, content
    end

    def edit_tag(options, message)
      tag = Tag.find_by id: options[:id]

      ::Tags::Update.call tag, params(message).slice(:user, options[:target].to_sym)
      Tags::UpdatedAnswer.render self, tag, options
    end

    def tags_list(options = {})
      user_tags = ::Tags::AllQuery.call Tag.all, user: current_user, content_id: options[:content_id]
      tags_count = user_tags.count
      tags = ::Tags::AllQuery.call user_tags, options.merge(limit: Telegram::PAGE_SIZE)
      start_next_page = ::Tags::NextPageStartQuery.call user_tags, tags, Telegram::PAGE_SIZE
      start_previous_page = ::Tags::PreviousPageStartQuery.call user_tags, tags

      params = options.merge(next_page_id: start_next_page&.id, previous_page_id: start_previous_page&.id)
      Tags::IndexAnswer.render self, tags, tags_count, params
    end

    def show_tag(options = {})
      tag = Tag.find_by(id: options[:id])
      Tags::ShowAnswer.render self, tag
    end

    def delete_tag(options = {})
      tag = Tag.find_by id: options[:id]
      Tags::DeleteAnswer.render self, tag
    end

    def destroy_tag(options = {})
      tag = Tag.find_by id: options[:id]
      ::Tags::Destroy.call tag
      Tags::DeletedAnswer.render self
    end

    def attach_tags_list(options = {})
      user_tags = ::Tags::AllQuery.call Tag.all, user: current_user, banned_content_id: options[:content_id]
      tags_count = user_tags.count
      tags = ::Tags::AllQuery.call user_tags, max_id: options[:max_id], limit: Telegram::PAGE_SIZE

      start_next_page = ::Tags::NextPageStartQuery.call user_tags, tags, Telegram::PAGE_SIZE
      start_previous_page = ::Tags::PreviousPageStartQuery.call user_tags, tags

      params = options.merge(next_page_id: start_next_page&.id, previous_page_id: start_previous_page&.id)
      Tags::AttachTagsListAnswer.render self, tags, tags_count, params
    end

    def detach_tags_list(options = {})
      user_tags = ::Tags::AllQuery.call Tag.all, user: current_user, content_id: options[:content_id]
      tags_count = user_tags.count
      tags = ::Tags::AllQuery.call user_tags, max_id: options[:max_id], limit: Telegram::PAGE_SIZE

      start_next_page = ::Tags::NextPageStartQuery.call user_tags, tags, Telegram::PAGE_SIZE
      start_previous_page = ::Tags::PreviousPageStartQuery.call user_tags, tags

      params = options.merge(next_page_id: start_next_page&.id, previous_page_id: start_previous_page&.id)
      Tags::DetachTagsListAnswer.render self, tags, tags_count, params
    end

    def params(message)
      { user: current_user, name: message['text'] }
    end
  end
end
