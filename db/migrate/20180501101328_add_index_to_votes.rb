class AddIndexToVotes < ActiveRecord::Migration[5.2]
  def change
    add_index :votes, [:user_id, :poll_id], unique: true
  end
end
