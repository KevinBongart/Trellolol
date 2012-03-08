class RenameListBeforeToListBeforeId < ActiveRecord::Migration
  def change
    rename_column :actions, :list_before, :list_before_trello_id
    rename_column :actions, :list_after, :list_after_trello_id
  end
end
