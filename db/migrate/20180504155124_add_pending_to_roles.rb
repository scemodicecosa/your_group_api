class AddPendingToRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :accepted, :boolean, default: false
  end
end
