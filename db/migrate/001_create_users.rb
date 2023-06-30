class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, force: true do |t|
      t.integer :user_id, null: false
      t.integer :group_id, null: false

      t.index %i[user_id group_id], unique: true
    end
  end
end
