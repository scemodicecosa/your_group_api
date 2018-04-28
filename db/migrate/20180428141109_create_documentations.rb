class CreateDocumentations < ActiveRecord::Migration[5.2]
  def change
    create_table :documentations do |t|
      t.text :title
      t.text :url
      t.text :method
      t.text :url_req
      t.text :url_opt
      t.text :params
      t.text :success_response
      t.text :error_response
      t.text :example
      t.text :note

      t.timestamps
    end
  end
end
