class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :trello_id
      t.string :name

      t.timestamps
    end
  end
end
