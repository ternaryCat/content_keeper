module Tags
  class AllQuery < BaseQuery
    option :user, optional: true
    option :previous_id, optional: true
    option :max_id, optional: true
    option :limit, optional: true
    option :content_id, optional: true
    option :banned_content_id, optional: true

    def call
      result = relation
      result = result.where(user: user) if user
      result = result.where('tags.id <= ?', max_id) if max_id
      result = with_content_id(result) if content_id
      result = without_content_id(result) if banned_content_id
      result = result.limit(limit) if limit
      result.order(id: :desc)
    end

    private

    def with_content_id(result)
      contents_tags = ContentReferencesTag.where(content_reference_id: content_id)
      result.where(id: contents_tags.pluck(:tag_id))
    end

    def without_content_id(result)
      contents_tags = ContentReferencesTag.where(content_reference_id: banned_content_id)
      result.where.not(id: contents_tags.pluck(:tag_id))
    end
  end
end
