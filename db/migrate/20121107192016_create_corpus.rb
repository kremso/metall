class CreateCorpus < ActiveRecord::Migration
  def change
    create_table :corpus do |t|
      t.string :language
      t.string :word
      t.integer :count
    end

    add_index :corpus, [:language, :word]
  end
end
