module ContentReferences
  class NextRecordQuery < BaseQuery
    param :user_contents

    def call
      last_record = relation.order(id: :asc).first
      return unless last_record

      user_contents.where('id > ?', last_record.id).limit(1).first
    end
  end
end
