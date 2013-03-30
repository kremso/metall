class CreateTableCorpusSk < ActiveRecord::Migration
  def change
    create_table :corpus_sk do |t|
      t.integer :category_id
      t.string :word
      t.integer :count
    end

    add_index :corpus_sk, [:category_id, :word]
  end
end
