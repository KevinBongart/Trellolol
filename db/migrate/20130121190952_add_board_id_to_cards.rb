class AddBoardIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :board_id, :string

  end
end
