class RemoveLanguageFromCorpus < ActiveRecord::Migration
  def change
    remove_index :corpus, [:language, :word]
    remove_column :corpus, :language
  end
end
