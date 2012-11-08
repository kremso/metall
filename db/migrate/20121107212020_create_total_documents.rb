class CreateTotalDocuments < ActiveRecord::Migration
  def change
    create_table :total_documents do |t|
      t.string :language
      t.integer :number
    end
  end
end
