class CreateStopwords < ActiveRecord::Migration
  def change
    create_table :stopwords do |t|
      t.string :language
      t.string :word
    end

    add_index :stopwords, :language
  end
end
