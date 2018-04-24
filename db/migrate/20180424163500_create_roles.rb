class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.boolean :admin, default: false
      t.belongs_to :user
      t.belongs_to :group

      t.timestamps
    end
  end
end
