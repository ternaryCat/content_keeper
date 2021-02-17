module ContentReferences
  class AllQuery < BaseQuery
    option :authentication, optional: true
    option :tag_id, optional: true
    option :max_id, optional: true
    option :limit, optional: true

    def call
      result = relation
      result = result.where(authentication: authentication) if authentication
      result = with_tag_id(result) if tag_id
      result = result.where('id <= ?', max_id) if max_id
      result = result.limit(limit) if limit
      result.order(id: :desc)
    end

    private

    def with_tag_id(result)
      contents_tags = ContentReferencesTag.where(tag_id: tag_id)
      result.where(id: contents_tags.pluck(:content_reference_id))
    end
  end
end
