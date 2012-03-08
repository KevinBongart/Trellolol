class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :key
      t.string :token

      t.timestamps
    end
  end
end
