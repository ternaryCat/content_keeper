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
        attach_tags_list: ->(options) { attach_tags_list(options) }
      }[action]
    end

    def last_action_strategy(action)
      {
        new_tag: ->(_options, message) { create_tag(message) },
        edit_tag: ->(options, message) { edit_tag(options, message) }
      }[action]
    end

    def create_tag(message)
      tag = ::Tags::Create.call params(message)
      Tags::CreatedAnswer.render self, tag
    end

    def edit_tag(options, message)
      tag = Tag.find_by id: options[:id]

      ::Tags::Update.call tag, params(message).slice(:user, options[:target].to_sym)
      Tags::UpdatedAnswer.render self, tag, options
    end

    def tags_list(options = {})
      user_tags = ::Tags::AllQuery.call Tag.all, user: current_user, content_id: options[:content_id]
      tags_count = user_tags.count
      tags = ::Tags::AllQuery.call user_tags, options.merge(limit: 5)
      previous_id = ::Tags::PreviousRecordQuery.call(tags, user_tags)&.id
      next_id = ::Tags::NextRecordQuery.call(tags, user_tags)&.id

      Tags::IndexAnswer.render self, tags, tags_count, options.merge(previous_id: previous_id, next_id: next_id)
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

    def attach_tags_list(options)
      user_tags = ::Tags::AllQuery.call Tag.all, user: current_user, banned_content_id: options[:content_id]
      tags_count = user_tags.count
      tags = ::Tags::AllQuery.call user_tags, options.slice(:previous_id, :next_id).merge(limit: 5)

      previous_id = ::Tags::PreviousRecordQuery.call(tags, user_tags)&.id
      next_id = ::Tags::NextRecordQuery.call(tags, user_tags)&.id

      Tags::AttachTagsListAnswer.render self,
                                        tags,
                                        tags_count,
                                        options.merge(previous_id: previous_id, next_id: next_id)
    end

    def params(message)
      { user: current_user, name: message['text'] }
    end
  end
end
