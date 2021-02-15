class CreateContentReferencesTags < ActiveRecord::Migration[6.1]
  def change
    create_table :content_references_tags do |t|
      t.belongs_to :content_reference
      t.belongs_to :tag
      t.timestamps
    end
  end
end
