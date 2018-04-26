class AddUserToPolls < ActiveRecord::Migration[5.2]
  def change
     add_belongs_to :polls, :user, foreign_key: true
  end
end
