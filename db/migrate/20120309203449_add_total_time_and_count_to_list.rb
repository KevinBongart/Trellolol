class AddTotalTimeAndCountToList < ActiveRecord::Migration
  def change
    add_column :lists, :total_time, :integer

    add_column :lists, :count, :integer

  end
end
