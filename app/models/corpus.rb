class Corpus < ActiveRecord::Base
  self.table_name = 'corpus_en'
  
  belongs_to :category

  def self.for_language(language)
  	Kernel.const_get("Corpus#{language.camelize}")
  end
end