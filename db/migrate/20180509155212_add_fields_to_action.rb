class AddFieldsToAction < ActiveRecord::Migration[5.2]
  def change
    add_column :actions, :done, :boolean,  default: false
    add_column :actions, :accepted, :boolean,  default: false
  end
end
