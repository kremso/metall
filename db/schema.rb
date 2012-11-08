# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121107212020) do

  create_table "corpus", :force => true do |t|
    t.string  "language"
    t.string  "word"
    t.integer "count"
  end

  add_index "corpus", ["language", "word"], :name => "index_corpus_on_language_and_word"

  create_table "stopwords", :force => true do |t|
    t.string "language"
    t.string "word"
  end

  add_index "stopwords", ["language"], :name => "index_stopwords_on_language"

  create_table "total_documents", :force => true do |t|
    t.string  "language"
    t.integer "number"
  end

end
