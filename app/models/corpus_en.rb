class CorpusEn < ActiveRecord::Base
  self.table_name = 'corpus_en'

  belongs_to :category
end