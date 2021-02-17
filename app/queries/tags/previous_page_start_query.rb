module Tags
  class PreviousPageStartQuery < BaseQuery
    param :page_contents

    def call
      last_record = page_contents.order(id: :desc).last
      return unless last_record

      relation.where('id < ?', last_record.id).order(id: :desc).first
    end
  end
end
