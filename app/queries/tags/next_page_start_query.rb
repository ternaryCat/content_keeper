module Tags
  class NextPageStartQuery < BaseQuery
    param :page_contents
    param :page_size

    def call
      first_record = page_contents.order(id: :desc).first
      return unless first_record

      relation.reorder(id: :asc).where('id >= ?', first_record.id).offset(page_size).first
    end
  end
end
