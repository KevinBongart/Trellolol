class AddTotalCompletedCardsToMetricGroup < ActiveRecord::Migration
  def change
    add_column :metric_groups, :total_completed_cards, :integer, :default => 0
  end
end
