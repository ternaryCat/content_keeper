module Tags
  class PreviousRecordQuery < BaseQuery
    param :user_tags

    def call
      first_record = relation.order(id: :desc).last
      return unless first_record

      user_tags.where('tags.id < ?', first_record.id).limit(1).first
    end
  end
end
