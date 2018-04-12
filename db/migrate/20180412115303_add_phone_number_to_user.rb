class AddPhoneNumberToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phone_number, :string
    #add_index :users, :phone_number, unique: true
  end
end
