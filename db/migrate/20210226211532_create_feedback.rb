class CreateFeedback < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.string :text, null: false
      t.integer :state, default: 0, null: false
      t.string :answer

      t.belongs_to :authentication
      t.timestamps
    end
  end
end
