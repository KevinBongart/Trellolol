class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.integer :metric_group_id
      t.integer :list_id
      t.integer :cards_count

      t.timestamps
    end
  end
end
