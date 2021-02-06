class CreateContentReference < ActiveRecord::Migration[6.1]
  def change
    create_table :content_references do |t|
      t.string :token, null: false
      t.string :name

      t.belongs_to :authentication
      t.timestamps
    end
  end
end
