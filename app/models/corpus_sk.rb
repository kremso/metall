class CorpusSk < ActiveRecord::Base
  self.table_name = 'corpus_sk'

  belongs_to :category
end