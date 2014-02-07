class CreateDocumentKeyword < ActiveRecord::Migration
  def change
    create_table :document_keywords do |t|
      t.integer :batch_keyword_request_id
      t.text :options
      t.text :result
      t.text :error
      t.boolean :done
      t.timestamps
    end

    add_index :document_keywords, :batch_keyword_request_id
    add_index :document_keywords, [:batch_keyword_request_id, :done]
  end
end
