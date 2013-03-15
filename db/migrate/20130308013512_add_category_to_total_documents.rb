class AddCategoryToTotalDocuments < ActiveRecord::Migration
  def change
    add_column :total_documents, :category_id, :integer, :after => :language
  end
end
