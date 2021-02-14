module ContentReferences
  class AllQuery < BaseQuery
    option :previous_id, optional: true
    option :next_id, optional: true
    option :limit, optional: true

    def call
      result = relation
      result = result.where('id <= ?', previous_id) if previous_id
      result = result.where('id >= ?', next_id) if next_id
      result = result.limit(limit) if limit
      result.order(id: :desc)
    end
  end
end
