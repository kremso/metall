class RenameCorpusToCorpusEn < ActiveRecord::Migration
  def change
    rename_table :corpus, :corpus_en
  end
end
