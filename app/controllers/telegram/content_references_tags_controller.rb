module Telegram
  class ContentReferencesTagsController < ApplicationController
    def callback_query(data)
      action, options = parse_action(data)
      callback_strategy(action.to_sym)&.call(options)
    rescue ::ContentReferencesTags::BaseService::NotFound
      ContentReferencesTags::NotFoundAnswer.render self
    rescue ::ContentReferencesTags::BaseService::NotFoundContent
      ContentReferences::NotFoundAnswer.render self
    rescue ::ContentReferencesTags::BaseService::NotFoundTag
      Tags::NotFoundAnswer.render self
    end

    private

    def callback_strategy(action)
      {
        attach_tag: ->(options) { attach_tag(options) },
        detach_tag: ->(options) { detach_tag(options) }
      }[action]
    end

    def attach_tag(options)
      content = ContentReference.find_by id: options[:content_id]
      tag = Tag.find_by id: options[:id]
      ::ContentReferencesTags::Attach.call content, tag
      ContentReferencesTags::AttachedAnswer.render self, content, tag
    rescue ::ContentReferencesTags::BaseService::NotFoundContent
      ContentReferences::NotFoundAnswer.render self
    rescue ::ContentReferencesTags::BaseService::NotFoundTag
      Tags::NotFoundAnswer.render self
    rescue ::ContentReferencesTags::Attach::Duplicate
      ContentReferencesTags::DuplicateAnswer.render self, content
    end

    def detach_tag(options)
      content = ContentReference.find_by id: options[:content_id]
      tag = Tag.find_by id: options[:id]
      ::ContentReferencesTags::Detach.call content, tag
      ContentReferencesTags::DetachedAnswer.render self, content, tag
    end
  end
end
