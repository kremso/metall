class CreateBatchKeywordRequests < ActiveRecord::Migration
  def change
    create_table :batch_keyword_requests do |t|
      t.string :uid
      t.string :callback_url
      t.timestamps
    end

    add_index :batch_keyword_requests, :uid
  end
end
