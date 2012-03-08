class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :trello_id
      t.string :name
      t.integer :board_id

      t.timestamps
    end
  end
end
