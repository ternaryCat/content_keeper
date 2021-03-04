class CreateMetrics < ActiveRecord::Migration[6.1]
  def change
    create_table :metrics do |t|
      t.string :title

      t.belongs_to :user
      t.timestamps
    end
  end
end
