class CreateMetricGroups < ActiveRecord::Migration
  def change
    create_table :metric_groups do |t|
      t.integer :board_id

      t.timestamps
    end
  end
end
