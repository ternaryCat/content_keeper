module ContentReferences
  class PreviousRecordQuery < BaseQuery
    param :user_contents

    def call
      first_record = relation.order(id: :desc).last
      return unless first_record

      user_contents.where('id < ?', first_record.id).limit(1).first
    end
  end
end
