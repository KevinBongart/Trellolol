class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :card_id
      t.string :trello_id
      t.string :list_before
      t.string :list_after
      t.timestamp :date

      t.timestamps
    end
  end
end
