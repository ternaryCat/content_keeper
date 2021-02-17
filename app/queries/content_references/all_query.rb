module ContentReferences
  class AllQuery < BaseQuery
    option :authentication, optional: true
    option :max_id, optional: true
    option :limit, optional: true

    def call
      result = relation
      result = result.where(authentication: authentication) if authentication
      result = result.where('id <= ?', max_id) if max_id
      result = result.limit(limit) if limit
      result.order(id: :desc)
    end
  end
end
