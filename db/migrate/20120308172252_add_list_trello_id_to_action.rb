class AddListTrelloIdToAction < ActiveRecord::Migration
  def change
    add_column :actions, :list_trello_id, :string

  end
end
