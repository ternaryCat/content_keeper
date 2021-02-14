module Tags
  class NextRecordQuery < BaseQuery
    param :user_tags

    def call
      last_record = relation.order(id: :asc).first
      return unless last_record

      user_tags.where('id > ?', last_record.id).limit(1).first
    end
  end
end
