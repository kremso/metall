class AddCategoryToCorpus < ActiveRecord::Migration
  def change
    add_column :corpus, :category_id, :integer, :after => :id
    add_index :corpus, [:category_id, :word]
  end
end
