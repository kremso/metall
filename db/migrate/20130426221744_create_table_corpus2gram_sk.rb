class CreateTableCorpus2gramSk < ActiveRecord::Migration
  def change
    create_table :corpus_2gram_sk do |t|
      t.string :words
      t.integer :count
    end

    add_index :corpus_2gram_sk, :words
  end
end
