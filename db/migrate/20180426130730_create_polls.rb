class CreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :polls do |t|
      t.string :question
      t.belongs_to :group, foreign_key: true
      t.text :answers

      t.timestamps
    end
  end
end
