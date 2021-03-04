module Telegram
  class TagsController < ApplicationController
    def callback_query(data)
      action, options = parse_action(data)
      callback_strategy(action.to_sym)&.call(options)
    rescue ::Tags::BaseService::NotFound
      Tags::NotFoundAnswer.render self
    end

    private

    def callback_strategy(action)
      {
        new_tag: ->(options) { Tags::NewAnswer.render self, options },
        cancel_tag_creating: ->(options) { Tags::CanceledCreatingAnswer.render self, options },
        edit_tag: ->(options) { Tags::EditAnswer.render self, options },
        cancel_tag_updating: ->(options) { Tags::CanceledUpdatingAnswer.render self, options },
        tags: ->(options) { tags_list(options) },
        show_tag: ->(options) { show_tag(options) },
        delete_tag: ->(options) { delete_tag(options) },
        cancel_deleting_tag: ->(options) { Tags::CanceledDeletingAnswer.render self, options },
        attach_tags_list: ->(options) { attach_tags_list(options) },
        detach_tags_list: ->(options) { detach_tags_list(options) }
      }[action]
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
      Tags::ShowAnswer.render self, tag, options
    end

    def delete_tag(options = {})
      tag = Tag.find_by id: options[:id]
      Tags::DeleteAnswer.render self, tag, options
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
  end
end
