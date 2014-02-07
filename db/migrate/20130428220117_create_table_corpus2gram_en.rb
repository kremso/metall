class CreateTableCorpus2gramEn < ActiveRecord::Migration
  def change
      create_table :corpus_2gram_en do |t|
        t.references :category
        t.string :words
        t.integer :count
      end

      add_index :corpus_2gram_en, [:category_id, :words]
    end
end
