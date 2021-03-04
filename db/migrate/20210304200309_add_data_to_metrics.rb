class AddDataToMetrics < ActiveRecord::Migration[6.1]
  def change
    add_column :metrics, :data, :jsonb
  end
end
