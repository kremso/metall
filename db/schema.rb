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

ActiveRecord::Schema.define(:version => 20140205213309) do

  create_table "batch_keyword_requests", :force => true do |t|
    t.string   "uid"
    t.string   "callback_url"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "batch_keyword_requests", ["uid"], :name => "index_batch_keyword_requests_on_uid"

  create_table "categories", :force => true do |t|
    t.string "language"
    t.string "name"
  end

  create_table "corpus_2gram_en", :force => true do |t|
    t.integer "category_id"
    t.string  "words"
    t.integer "count"
  end

  add_index "corpus_2gram_en", ["category_id", "words"], :name => "index_corpus_2gram_en_on_category_id_and_words"

  create_table "corpus_2gram_sk", :force => true do |t|
    t.string  "words"
    t.integer "count"
  end

  add_index "corpus_2gram_sk", ["words"], :name => "index_corpus_2gram_sk_on_words"

  create_table "corpus_en", :force => true do |t|
    t.string  "word"
    t.integer "count"
    t.integer "category_id"
  end

  add_index "corpus_en", ["category_id", "word"], :name => "index_corpus_on_category_id_and_word"

  create_table "corpus_sk", :force => true do |t|
    t.integer "category_id"
    t.string  "word"
    t.integer "count"
  end

  add_index "corpus_sk", ["category_id", "word"], :name => "index_corpus_sk_on_category_id_and_word"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "document_keywords", :force => true do |t|
    t.integer  "batch_keyword_request_id"
    t.text     "options"
    t.text     "result"
    t.text     "error"
    t.boolean  "done"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "document_keywords", ["batch_keyword_request_id", "done"], :name => "index_document_keywords_on_batch_keyword_request_id_and_done"
  add_index "document_keywords", ["batch_keyword_request_id"], :name => "index_document_keywords_on_batch_keyword_request_id"

  create_table "stopwords", :force => true do |t|
    t.string "language"
    t.string "word"
  end

  add_index "stopwords", ["language"], :name => "index_stopwords_on_language"

  create_table "total_documents", :force => true do |t|
    t.string  "language"
    t.integer "number"
    t.integer "category_id"
  end

end
